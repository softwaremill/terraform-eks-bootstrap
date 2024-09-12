package test

import (
	"context"
	"encoding/base64"
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/eks"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	appsv1 "k8s.io/api/apps/v1"
	apiv1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
	"k8s.io/utils/pointer"
	"sigs.k8s.io/aws-iam-authenticator/pkg/token"
)

func createRestConfig(eks *eks.Cluster) (*rest.Config, error) {
	tokenGenerator, err := token.NewGenerator(true, false)
	if err != nil {
		return nil, err
	}
	options := &token.GetTokenOptions{ClusterID: aws.StringValue(eks.Name)}
	tok, err := tokenGenerator.GetWithOptions(options)
	if err != nil {
		return nil, err
	}
	ca, err := base64.StdEncoding.DecodeString(aws.StringValue(eks.CertificateAuthority.Data))
	if err != nil {
		return nil, err
	}
	restConfig := rest.Config{
		Host:        aws.StringValue(eks.Endpoint),
		BearerToken: tok.Token,
		TLSClientConfig: rest.TLSClientConfig{
			CAData: ca,
		},
	}
	return &restConfig, nil
}

func createK8sClientset(restConfig *rest.Config) (*kubernetes.Clientset, error) {
	clientSet, err := kubernetes.NewForConfig(restConfig)
	if err != nil {
		return nil, err
	}
	return clientSet, nil
}

func createTestDeployment(clientset *kubernetes.Clientset, deplName string) (*appsv1.Deployment, error) {
	delploymentClient := clientset.AppsV1().Deployments(apiv1.NamespaceDefault)
	deployment := &appsv1.Deployment{
		ObjectMeta: metav1.ObjectMeta{Name: deplName},
		Spec: appsv1.DeploymentSpec{
			Replicas: pointer.Int32(2),
			Selector: &metav1.LabelSelector{
				MatchLabels: map[string]string{
					"app": deplName,
				},
			},
			Template: apiv1.PodTemplateSpec{
				ObjectMeta: metav1.ObjectMeta{
					Labels: map[string]string{
						"app": deplName,
					},
				},
				Spec: apiv1.PodSpec{
					Containers: []apiv1.Container{
						{
							Name:  "nginx",
							Image: "nginx",
							Ports: []apiv1.ContainerPort{
								{
									Name:          "http",
									Protocol:      apiv1.ProtocolTCP,
									ContainerPort: 80,
								},
							},
						},
					},
				},
			},
		},
	}

	result, err := delploymentClient.Create(context.TODO(), deployment, metav1.CreateOptions{})
	if err != nil {
		return nil, err
	}
	fmt.Printf("Deployment %s created.\n", result.Name)
	return result, nil
}
func TestComplete(t *testing.T) {
	t.Parallel()

	awsRegion := "eu-west-1"
	randId := strings.ToLower(random.UniqueId())
	deplName := "nginx-" + randId

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/complete",
		Vars: map[string]interface{}{
			"region":       awsRegion,
			"names_suffix": randId,
		},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	vpcName := terraform.Output(t, terraformOptions, "vpc_name")
	assert.Equal(t, "terraform-example-"+randId+"-vpc", vpcName)

	clusterName := terraform.Output(t, terraformOptions, "eks_cluster_name")
	assert.Equal(t, "eks-cluster-"+randId, clusterName)

	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(awsRegion),
	})
	assert.NoError(t, err)

	eksSvc := eks.New(sess)
	describeResult, err := eksSvc.DescribeCluster(&eks.DescribeClusterInput{
		Name: aws.String(clusterName),
	})
	assert.NoError(t, err)

	// Create a kubeconfig from and prepare the kubectlOptions
	restConfig, err := createRestConfig(describeResult.Cluster)
	assert.NoError(t, err)

	k8sClientSet, err := createK8sClientset(restConfig)
	assert.NoError(t, err)

	assert.NoError(t, err)

	kubectlOptions := k8s.NewKubectlOptionsWithRestConfig(restConfig, "default")

	deployment, err := createTestDeployment(k8sClientSet, deplName)
	assert.NoError(t, err)

	k8s.WaitUntilDeploymentAvailable(t, kubectlOptions, deployment.Name, 10, 5*time.Second)

}
