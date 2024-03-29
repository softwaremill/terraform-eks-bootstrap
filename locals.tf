locals {

  #############
  # VPC
  #############
  vpc_name                        = "${var.org}-${var.environment}-vpc"
  azs_names                       = data.aws_availability_zones.available.names
  azs_count                       = length(local.azs_names)
  public_subnet_cidrs             = [for step in range(local.azs_count) : cidrsubnet(var.vpc_cidr, 5, step)]
  private_subnet_cidrs            = [for step in range(local.azs_count) : cidrsubnet(var.vpc_cidr, 5, step + local.azs_count)]
  private_subnets                 = var.create_vpc ? module.vpc[0].private_subnets : var.private_subnet_ids
  eks_managed_node_group_defaults = var.eks_single_az ? merge(var.eks_cluster_node_groups_default_configuration, { subnet_ids = slice(local.private_subnets, 0, 1) }) : merge(var.eks_cluster_node_groups_default_configuration, { subnet_ids = local.private_subnets })

  tags = merge({
    environment = var.environment
    createdBy   = "terraform"
  }, var.additional_tags)

  ###############
  # Storage class
  ###############
  storage_classes_names = [for sc in toset(var.eks_storage_classes) : sc.name]
  storage_classes       = zipmap(local.storage_classes_names, tolist(toset(var.eks_storage_classes)))

  ###############
  # Add-ons
  ###############
  ebs_csi_addon = {
    aws-ebs-csi-driver = {
      resolve_conflicts        = "OVERWRITE"
      preserve                 = true
      most_recent              = true
      service_account_role_arn = module.ebs_csi_irsa_role.0.iam_role_arn
    }
  }

  cluster_addons = var.enable_ebs_csi_driver ? merge(
    var.eks_default_cluster_addons,
    var.eks_additional_cluster_addons,
    local.ebs_csi_addon
    ) : merge(
    var.eks_default_cluster_addons,
    var.eks_additional_cluster_addons
  )
}
