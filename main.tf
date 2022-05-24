module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc_name
  cidr = var.vpc_cidr

  azs             = local.azs_names
  private_subnets = local.private_subnet_cidrs
  public_subnets  = local.public_subnet_cidrs

  enable_nat_gateway     = var.vpc_nat_setting.enable_nat_gateway
  single_nat_gateway     = !var.vpc_nat_setting.multi_az_nat_gateway
  one_nat_gateway_per_az = var.vpc_nat_setting.multi_az_nat_gateway
  enable_dns_hostnames   = true # require set to true for enabling cluster private access
  enable_dns_support     = true # require set to true for enabling cluster private access


  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared",
    "kubernetes.io/role/elb"                        = "1"
    "subnet"                                        = "public"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
    "subnet"                                        = "private"
  }
  tags = local.tags
}

module "kubernetes_secrets_encryption_key" {
  source      = "./modules/encryption"
  org         = var.org
  environment = var.environment
  tags        = local.tags
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = concat(module.vpc.public_subnets, module.vpc.private_subnets)

  cluster_endpoint_private_access = var.eks_cluster_endpoint_access.enable_private_access
  cluster_endpoint_public_access  = var.eks_cluster_endpoint_access.enable_public_access
  create_cluster_security_group   = true
  create_node_security_group      = true
  cluster_enabled_log_types       = var.eks_cluster_log_types

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  cluster_encryption_config = [
    {
      provider_key_arn = module.kubernetes_secrets_encryption_key.kubernetes_secrets_encryption_key_arn
      resources        = ["secrets"]
    }
  ]


  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = var.eks_cluster_default_node_group
  eks_managed_node_groups         = var.eks_cluster_additional_node_groups

  # Fargate Profile(s)
  fargate_profiles = var.eks_cluster_fargate_profiles

  # aws-auth configmap
  manage_aws_auth_configmap = true
  aws_auth_roles = var.eks_cluster_auth_role
  aws_auth_users = var.eks_cluster_auth_user


  tags = local.tags
}