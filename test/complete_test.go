package test

import (
	"context"
	"encoding/base64"
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/eks"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	appsv1 "k8s.io/api/apps/v1"
	apiv1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/informers"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/cache"
	"k8s.io/utils/pointer"
	"sigs.k8s.io/aws-iam-authenticator/pkg/token"
	"sync/atomic"
	"testing"
	"time"
)

func createK8sClientset(eks *eks.Cluster) (*kubernetes.Clientset, error) {
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
	clientSet, err := kubernetes.NewForConfig(
		&rest.Config{
			Host:        aws.StringValue(eks.Endpoint),
			BearerToken: tok.Token,
			TLSClientConfig: rest.TLSClientConfig{
				CAData: ca,
			},
		})
	if err != nil {
		return nil, err
	}
	return clientSet, nil
}
func TestComplete(t *testing.T) {
	t.Parallel()
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/complete",
	})
	//defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	vpcName := terraform.Output(t, terraformOptions, "vpc_name")
	assert.Equal(t, "terraform-example-vpc", vpcName)

	clusterName := terraform.Output(t, terraformOptions, "eks_cluster_name")
	assert.Equal(t, "eks-cluster", clusterName)

	sess, err := session.NewSession(&aws.Config{
		Region: aws.String("eu-west-1"),
	})
	assert.NoError(t, err)

	eksSvc := eks.New(sess)
	describeResult, err := eksSvc.DescribeCluster(&eks.DescribeClusterInput{
		Name: aws.String(clusterName),
	})
	assert.NoError(t, err)

	k8sClientSet, err := createK8sClientset(describeResult.Cluster)
	assert.NoError(t, err)

	var podsCount uint32 = 0
	factory := informers.NewSharedInformerFactoryWithOptions(
		k8sClientSet,
		5*time.Second,
		informers.WithNamespace("default"),
		informers.WithTweakListOptions(func(options *metav1.ListOptions) {
			options.LabelSelector = "app=test"
		}),
	)
	informer := factory.Core().V1().Pods().Informer()
	stopper := make(chan struct{})
	informer.AddEventHandler(cache.ResourceEventHandlerFuncs{
		AddFunc: func(obj interface{}) {
			pod := obj.(*apiv1.Pod)
			fmt.Printf("Pod %s added\n", pod.Name)
			atomic.AddUint32(&podsCount, 1)
			if podsCount == 2 {
				close(stopper)
			}
		},
	})
	go informer.Run(stopper)

	delploymentClient := k8sClientSet.AppsV1().Deployments(apiv1.NamespaceDefault)
	deployment := &appsv1.Deployment{
		ObjectMeta: metav1.ObjectMeta{Name: "nginx-test"},
		Spec: appsv1.DeploymentSpec{
			Replicas: pointer.Int32(2),
			Selector: &metav1.LabelSelector{
				MatchLabels: map[string]string{
					"app": "test",
				},
			},
			Template: apiv1.PodTemplateSpec{
				ObjectMeta: metav1.ObjectMeta{
					Labels: map[string]string{
						"app": "test",
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

	_, err = delploymentClient.Create(context.TODO(), deployment, metav1.CreateOptions{})
	assert.NoError(t, err)

	select {
	case <-stopper:
		msg := "Deployment scaled properly"
		fmt.Println(msg)
	case <-time.After(20 * time.Second):
		msg := "Deployment failed after 20s"
		fmt.Println(msg)
		assert.Fail(t, msg)
	}
}
