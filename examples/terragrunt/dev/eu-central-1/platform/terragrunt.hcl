terraform {
  source = "../../../../..//."
}

include {
  path = find_in_parent_folders()
}

inputs = {
  vpc_cidr            = "172.168.0.0/16"
  eks_cluster_version = "1.22"
  eks_cluster_name    = "sml-example-cluster"
  eks_cluster_node_groups = {
    additional = {
      min_size       = 1
      max_size       = 10
      desired_size   = 1
      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }
  
  eks_enable_secret_encryption = false

  eks_single_az                = true

  azs = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]

  eks_enable_secret_encryption = false

  eks_cluster_auth_user = [{
    userarn  = "arn:aws:iam::11111111111:user/user1"
    username = "user1"
    groups   = ["system:masters"]
  }]

  additional_tags = {
    project = "example-cluster"
  }


}