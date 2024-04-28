# Terraform EKS module

The module is designed to create AWS EKS cluster with all necessary AWS resources such as: 

- VPC network and subnets with [proper tagging](https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html#:~:text=.-,Subnet%20tagging,-For%201.18%20and), 
- Security Groups
- NAT Gateways
- AWS KMS encryption key to envelope encrypt Kubernetes Secrets
- AWS EKS clusters with default node group

### Available Features
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.47.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.29.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ebs_csi_irsa_role"></a> [ebs\_csi\_irsa\_role](#module\_ebs\_csi\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.24.0 |
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 19.19.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.0.0 |

## Resources

| Name | Type |
|------|------|
| [kubernetes_storage_class.storage_class](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Additional tags to include | `map(string)` | `{}` | no |
| <a name="input_create_aws_auth_configmap"></a> [create\_aws\_auth\_configmap](#input\_create\_aws\_auth\_configmap) | Should Terraform create aws\_auth ConfigMap used for setting up cluster access | `bool` | `false` | no |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | Specifies if new VPC be created, if not `vpc_id` and `subnet_ids` variables need to be provided | `bool` | `true` | no |
| <a name="input_eks_additional_cluster_addons"></a> [eks\_additional\_cluster\_addons](#input\_eks\_additional\_cluster\_addons) | Map of additional cluster addon configurations to enable for the cluster. | `any` | `{}` | no |
| <a name="input_eks_cluster_auth_role"></a> [eks\_cluster\_auth\_role](#input\_eks\_cluster\_auth\_role) | AWS roles with access permission to EKS cluster | <pre>list(object({<br>    rolearn : string<br>    username : string<br>    groups = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_eks_cluster_auth_user"></a> [eks\_cluster\_auth\_user](#input\_eks\_cluster\_auth\_user) | AWS users with access permission to EKS cluster | <pre>list(object({<br>    userarn : string<br>    username : string<br>    groups = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_eks_cluster_endpoint_access"></a> [eks\_cluster\_endpoint\_access](#input\_eks\_cluster\_endpoint\_access) | EKS managed node group default configurations | <pre>object({<br>    enable_public_access : bool<br>    enable_private_access : bool<br>  })</pre> | <pre>{<br>  "enable_private_access": false,<br>  "enable_public_access": true<br>}</pre> | no |
| <a name="input_eks_cluster_fargate_profiles"></a> [eks\_cluster\_fargate\_profiles](#input\_eks\_cluster\_fargate\_profiles) | EKS Fargate profile object | `map(object({}))` | `{}` | no |
| <a name="input_eks_cluster_log_types"></a> [eks\_cluster\_log\_types](#input\_eks\_cluster\_log\_types) | A list of the desired control plane logs to enable | `list(string)` | <pre>[<br>  "api",<br>  "audit",<br>  "authenticator"<br>]</pre> | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of the Kubernetes cluster | `string` | `"eks-cluster"` | no |
| <a name="input_eks_cluster_node_groups"></a> [eks\_cluster\_node\_groups](#input\_eks\_cluster\_node\_groups) | EKS managed additional node group | `any` | `{}` | no |
| <a name="input_eks_cluster_node_groups_default_configuration"></a> [eks\_cluster\_node\_groups\_default\_configuration](#input\_eks\_cluster\_node\_groups\_default\_configuration) | EKS managed node group default configurations | `any` | <pre>{<br>  "attach_cluster_primary_security_group": true,<br>  "desired_size": 3,<br>  "disk_size": 40,<br>  "instance_types": [<br>    "m5.large"<br>  ],<br>  "labels": {<br>    "node-group": "default"<br>  },<br>  "max_size": 5,<br>  "min_size": 1<br>}</pre> | no |
| <a name="input_eks_cluster_version"></a> [eks\_cluster\_version](#input\_eks\_cluster\_version) | Kubernetes cluster version | `string` | `"1.26"` | no |
| <a name="input_eks_create"></a> [eks\_create](#input\_eks\_create) | Specifies if actually create the EKS cluster | `bool` | `true` | no |
| <a name="input_eks_default_cluster_addons"></a> [eks\_default\_cluster\_addons](#input\_eks\_default\_cluster\_addons) | Map of default cluster addon configurations to enable for the cluster. | `any` | <pre>{<br>  "coredns": {<br>    "most_recent": true,<br>    "preserve": true,<br>    "resolve_conflicts": "OVERWRITE"<br>  },<br>  "kube-proxy": {<br>    "most_recent": true,<br>    "preserve": true,<br>    "resolve_conflicts": "OVERWRITE"<br>  },<br>  "vpc-cni": {<br>    "most_recent": true,<br>    "preserve": true,<br>    "resolve_conflicts": "OVERWRITE"<br>  }<br>}</pre> | no |
| <a name="input_eks_enable_secret_encryption"></a> [eks\_enable\_secret\_encryption](#input\_eks\_enable\_secret\_encryption) | Should KMS key to encrypt kubernetes secrets be generated | `bool` | `true` | no |
| <a name="input_eks_single_az"></a> [eks\_single\_az](#input\_eks\_single\_az) | Specifies if all node's should be deployed in the same AZ | `bool` | `false` | no |
| <a name="input_eks_storage_classes"></a> [eks\_storage\_classes](#input\_eks\_storage\_classes) | EBS storage class with custom parameters | <pre>list(object({<br>    name                      = string<br>    storage_class_provisioner = string<br>    parameters                = optional(map(string))<br>    volume_binding_mode       = optional(string)<br>    reclaim_policy            = optional(string)<br><br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_enable_bastion"></a> [enable\_bastion](#input\_enable\_bastion) | True if bastion host should be created | `bool` | `false` | no |
| <a name="input_enable_ebs_csi_driver"></a> [enable\_ebs\_csi\_driver](#input\_enable\_ebs\_csi\_driver) | Specifies if enable the EBS/CSI driver | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | n/a | yes |
| <a name="input_logs_retention_days"></a> [logs\_retention\_days](#input\_logs\_retention\_days) | Log retention in days | `number` | `14` | no |
| <a name="input_manage_aws_auth_configmap"></a> [manage\_aws\_auth\_configmap](#input\_manage\_aws\_auth\_configmap) | Should Terraform manage aws\_auth ConfigMap used for setting up cluster access | `bool` | `true` | no |
| <a name="input_org"></a> [org](#input\_org) | Organization name - part of other resource names | `string` | `"terraform"` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | List of IDs of existing private subnets, only used when `create_vpc` is set to `false` | `list(string)` | `[]` | no |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | List of IDs of existing public subnets, only used when `create_vpc` is set to `false` | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"eu-central-1"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPC CIDR address | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of existing VPC, only used when `create_vpc` is set to `false` | `string` | `""` | no |
| <a name="input_vpc_nat_setting"></a> [vpc\_nat\_setting](#input\_vpc\_nat\_setting) | Enable NAT Gateway | <pre>object({<br>    enable_nat_gateway : bool<br>    multi_az_nat_gateway : bool<br>  })</pre> | <pre>{<br>  "enable_nat_gateway": true,<br>  "multi_az_nat_gateway": false<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_arn"></a> [eks\_cluster\_arn](#output\_eks\_cluster\_arn) | ARN of the cluster |
| <a name="output_eks_cluster_certificate_authority_data"></a> [eks\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | Base64 encoded certificate data required to communicate with the cluster |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint for your Kubernetes API server |
| <a name="output_eks_cluster_id"></a> [eks\_cluster\_id](#output\_eks\_cluster\_id) | The id of the cluster |
| <a name="output_eks_cluster_name"></a> [eks\_cluster\_name](#output\_eks\_cluster\_name) | The name of the cluster |
| <a name="output_eks_cluster_oidc_issuer_arn"></a> [eks\_cluster\_oidc\_issuer\_arn](#output\_eks\_cluster\_oidc\_issuer\_arn) | The ARN on the EKS cluster OIDC provider |
| <a name="output_eks_cluster_oidc_issuer_url"></a> [eks\_cluster\_oidc\_issuer\_url](#output\_eks\_cluster\_oidc\_issuer\_url) | The URL on the EKS cluster OIDC Issuer |
| <a name="output_eks_cluster_primary_security_group_id"></a> [eks\_cluster\_primary\_security\_group\_id](#output\_eks\_cluster\_primary\_security\_group\_id) | The cluster primary security group ID created by the EKS cluster |
| <a name="output_eks_cluster_version"></a> [eks\_cluster\_version](#output\_eks\_cluster\_version) | The Kubernetes server version for the EKS cluster. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The VPC ID |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | The name of the VPC |
| <a name="output_vpc_nats_ids"></a> [vpc\_nats\_ids](#output\_vpc\_nats\_ids) | The list of allocation ID for Elastic IPs |
| <a name="output_vpc_private_route_table_ids"></a> [vpc\_private\_route\_table\_ids](#output\_vpc\_private\_route\_table\_ids) | The list of IDs of private route tables |
| <a name="output_vpc_private_subnets_ids"></a> [vpc\_private\_subnets\_ids](#output\_vpc\_private\_subnets\_ids) | The list of private subnets IDs associated with the VPC |
| <a name="output_vpc_public_route_table_ids"></a> [vpc\_public\_route\_table\_ids](#output\_vpc\_public\_route\_table\_ids) | The list of IDs of public route tables |
| <a name="output_vpc_public_subnets_ids"></a> [vpc\_public\_subnets\_ids](#output\_vpc\_public\_subnets\_ids) | The list of public subnets IDs associated with the VPC |
<!-- END_TF_DOCS -->
## eks_storage_classes variable
The eks_storage_classes variable takes the following parameters:
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="name"></a> [name](#name) | Standard storage class's name in metadata | `string` | "" | Required |
| <a name="storage_class_provisioner"></a> [storage_class_provisioner](#storage_class_provisioner) | Indicates the type of the provisioner | `string` | "" | Required |
| <a name="parameters"></a> [parameters](#parameters) | The parameters for the provisioner that should create volumes of this storage class. See the documentaion for the [available parameters](https://kubernetes.io/docs/concepts/storage/storage-classes/#parameters) | `map(string)` | {} | Optional |
| <a name="volume_binding_mode"></a> [volume\_binding\_mode](#volume\_binding\_mode) | Indicates when volume binding and dynamic provisioning should occur | `string` | "WaitForFirstConsumer" | Optional |
| <a name="reclaim_policy"></a> [reclaim\_policy](#reclaim\_policy) | Indicates the reclaim policy to use | `string` | "Delete" | Optional |


