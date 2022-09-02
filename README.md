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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.29.0 |


## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 18.0 |
| <a name="module_kubernetes_secrets_encryption_key"></a> [kubernetes\_secrets\_encryption\_key](#module\_kubernetes\_secrets\_encryption\_key) | ./modules/encryption | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Additional tags to include | `map(string)` | `{}` | no |
| <a name="input_eks_additional_cluster_addons"></a> [eks\_additional\_cluster\_addons](#input\_eks\_additional\_cluster\_addons) | Map of additional cluster addon configurations to enable for the cluster. Addon name can be the map keys or set with `name` | `any` | `{}` | no |
| <a name="input_eks_cluster_auth_role"></a> [eks\_cluster\_auth\_role](#input\_eks\_cluster\_auth\_role) | AWS roles with access permission to EKS cluster | <pre>list(object({<br>    rolearn : string<br>    username : string<br>    groups = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_eks_cluster_auth_user"></a> [eks\_cluster\_auth\_user](#input\_eks\_cluster\_auth\_user) | AWS users with access permission to EKS cluster | <pre>list(object({<br>    userarn : string<br>    username : string<br>    groups = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_eks_cluster_endpoint_access"></a> [eks\_cluster\_endpoint\_access](#input\_eks\_cluster\_endpoint\_access) | EKS managed node group default configurations | <pre>object({<br>    enable_public_access : bool<br>    enable_private_access : bool<br>  })</pre> | <pre>{<br>  "enable_private_access": false,<br>  "enable_public_access": true<br>}</pre> | no |
| <a name="input_eks_cluster_fargate_profiles"></a> [eks\_cluster\_fargate\_profiles](#input\_eks\_cluster\_fargate\_profiles) | EKS Fargate profile object | `map(object({}))` | `{}` | no |
| <a name="input_eks_cluster_log_types"></a> [eks\_cluster\_log\_types](#input\_eks\_cluster\_log\_types) | A list of the desired control plane logs to enable | `list(string)` | <pre>[<br>  "api",<br>  "audit",<br>  "authenticator"<br>]</pre> | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of the Kubernetes cluster | `string` | `"eks-cluster"` | no |
| <a name="input_eks_cluster_node_groups"></a> [eks\_cluster\_node\_groups](#input\_eks\_cluster\_node\_groups) | EKS managed additional node group | `any` | `{}` | no |
| <a name="input_eks_cluster_node_groups_default_configuration"></a> [eks\_cluster\_node\_groups\_default\_configuration](#input\_eks\_cluster\_node\_groups\_default\_configuration) | EKS managed node group default configurations | `any` | <pre>{<br>  "attach_cluster_primary_security_group": true,<br>  "desired_size": 3,<br>  "disk_size": 40,<br>  "instance_types": [<br>    "m5.large"<br>  ],<br>  "labels": {<br>    "node-group": "default"<br>  },<br>  "max_size": 5,<br>  "min_size": 1<br>}</pre> | no |
| <a name="input_eks_cluster_version"></a> [eks\_cluster\_version](#input\_eks\_cluster\_version) | Kubernetes cluster version | `string` | `"1.22"` | no |
| <a name="input_eks_default_cluster_addons"></a> [eks\_default\_cluster\_addons](#input\_eks\_default\_cluster\_addons) | Map of default cluster addon configurations to enable for the cluster. | `any` | <pre>{<br>  "coredns": {<br>    "resolve_conflicts": "OVERWRITE"<br>  },<br>  "vpc-cni": {<br>    "resolve_conflicts": "OVERWRITE"<br>  }<br>}</pre> | no |
| <a name="input_enable_bastion"></a> [enable\_bastion](#input\_enable\_bastion) | True if bastion host should be created | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | n/a | yes |
| <a name="input_logs_retention_days"></a> [logs\_retention\_days](#input\_logs\_retention\_days) | Log retention in days | `number` | `14` | no |
| <a name="input_org"></a> [org](#input\_org) | Organization name - part of other resource names | `string` | `"terraform"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"eu-central-1"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPC CIDR address | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_nat_setting"></a> [vpc\_nat\_setting](#input\_vpc\_nat\_setting) | Enable NAT Gateway | <pre>object({<br>    enable_nat_gateway : bool<br>    multi_az_nat_gateway : bool<br>  })</pre> | <pre>{<br>  "enable_nat_gateway": true,<br>  "multi_az_nat_gateway": false<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_arn"></a> [eks\_cluster\_arn](#output\_eks\_cluster\_arn) | ARN of the cluster |
| <a name="output_eks_cluster_certificate_authority_data"></a> [eks\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | Base64 encoded certificate data required to communicate with the cluster |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint for your Kubernetes API server |
| <a name="output_eks_cluster_id"></a> [eks\_cluster\_id](#output\_eks\_cluster\_id) | The name of the cluster |
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