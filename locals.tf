locals {

  #############
  # VPC
  #############
  vpc_name                        = "${var.org}-${var.environment}-vpc"
  azs_names                       = data.aws_availability_zones.available.names
  azs_count                       = length(local.azs_names)
  public_subnet_cidrs             = [for step in range(local.azs_count) : cidrsubnet(var.vpc_cidr, 5, step)]
  private_subnet_cidrs            = [for step in range(local.azs_count) : cidrsubnet(var.vpc_cidr, 5, step + local.azs_count)]
  eks_managed_node_group_defaults = var.eks_single_az ? merge(var.eks_cluster_node_groups_default_configuration, { subnet_ids = slice(module.vpc.private_subnets, 0, 1) }) : merge(var.eks_cluster_node_groups_default_configuration, { subnet_ids = module.vpc.private_subnets })

  tags = merge({
    environment = var.environment
    createdBy   = "terraform"
  }, var.additional_tags)

  ###############
  # Storage class
  ###############
  storage_classes_names = [for sc in toset(var.eks_storage_classes) : sc.name]
  storage_classes       = zipmap(local.storage_classes_names, tolist(toset(var.eks_storage_classes)))
}
