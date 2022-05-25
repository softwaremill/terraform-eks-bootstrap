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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.15.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 18.0 |
| <a name="module_kubernetes_secrets_encryption_key"></a> [kubernetes\_secrets\_encryption\_key](#module\_kubernetes\_secrets\_encryption\_key) | ./modules/encryption | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | n/a |

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
| <a name="input_eks_cluster_auth_role"></a> [eks\_cluster\_auth\_role](#input\_eks\_cluster\_auth\_role) | AWS roles with access permission to EKS cluster | <pre>list(object({<br>    rolearn : string<br>    username : string<br>    groups = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_eks_cluster_auth_user"></a> [eks\_cluster\_auth\_user](#input\_eks\_cluster\_auth\_user) | AWS users with access permission to EKS cluster | <pre>list(object({<br>    userarn : string<br>    username : string<br>    groups = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_eks_cluster_endpoint_access"></a> [eks\_cluster\_endpoint\_access](#input\_eks\_cluster\_endpoint\_access) | EKS managed node group default configurations | <pre>object({<br>    enable_public_access : bool<br>    enable_private_access : bool<br>  })</pre> | <pre>{<br>  "enable_private_access": false,<br>  "enable_public_access": true<br>}</pre> | no |
| <a name="input_eks_cluster_fargate_profiles"></a> [eks\_cluster\_fargate\_profiles](#input\_eks\_cluster\_fargate\_profiles) | EKS Fargate profile object | `map(object({}))` | `{}` | no |
| <a name="input_eks_cluster_log_types"></a> [eks\_cluster\_log\_types](#input\_eks\_cluster\_log\_types) | A list of the desired control plane logs to enable | `list(string)` | <pre>[<br>  "api",<br>  "audit",<br>  "authenticator"<br>]</pre> | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of the Kubernetes cluster | `string` | `"eks-cluster"` | no |
| <a name="input_eks_cluster_node_groups"></a> [eks\_cluster\_node\_groups](#input\_eks\_cluster\_node\_groups) | EKS managed additional node group | `any` | `{}` | no |
| <a name="input_eks_cluster_node_groups_default_configuration"></a> [eks\_cluster\_node\_groups\_default\_configuration](#input\_eks\_cluster\_node\_groups\_default\_configuration) | EKS managed node group default configurations | `any` | <pre>{<br>  "attach_cluster_primary_security_group": true,<br>  "desired_size": 3,<br>  "disk_size": 40,<br>  "instance_types": [<br>    "m5.large"<br>  ],<br>  "labels": {<br>    "node-group": "default"<br>  },<br>  "max_size": 5,<br>  "min_size": 1<br>}</pre> | no |
| <a name="input_eks_cluster_version"></a> [eks\_cluster\_version](#input\_eks\_cluster\_version) | Kubernetes cluster version | `string` | `"1.22"` | no |
| <a name="input_enable_bastion"></a> [enable\_bastion](#input\_enable\_bastion) | True if bastion host should be created | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | n/a | yes |
| <a name="input_logs_retention_days"></a> [logs\_retention\_days](#input\_logs\_retention\_days) | Log retention in days | `number` | `14` | no |
| <a name="input_org"></a> [org](#input\_org) | Organization name - part of other resource names | `string` | `"terraform"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"eu-central-1"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPC CIDR address | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_nat_setting"></a> [vpc\_nat\_setting](#input\_vpc\_nat\_setting) | Enable NAT Gateway | <pre>object({<br>    enable_nat_gateway : bool<br>    multi_az_nat_gateway : bool<br>  })</pre> | <pre>{<br>  "enable_nat_gateway": true,<br>  "multi_az_nat_gateway": false<br>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->