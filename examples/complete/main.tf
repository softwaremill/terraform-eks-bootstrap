provider "aws" {}
provider "kubernetes" {
  host                   = module.complete.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.complete.eks_cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.complete.eks_cluster_name]
  }
}
module "complete" {
  source           = "../.."
  environment      = "example-${var.names_suffix}"
  eks_cluster_name = "eks-cluster-${var.names_suffix}"
  eks_cluster_node_groups = {
    default = {
      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
      desired_size   = 1
    }
  }
}
