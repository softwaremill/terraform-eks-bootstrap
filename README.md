# Terraform EKS module

The module is designed to create AWS EKS cluster with all necessary AWS resources such as: 

- VPC network and subnets with [proper tagging](https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html#:~:text=.-,Subnet%20tagging,-For%201.18%20and), 
- Security Groups
- NAT Gateways
- AWS KMS encryption key to envelope encrypt Kubernetes Secrets
- AWS EKS clusters with default node group

### Available Features