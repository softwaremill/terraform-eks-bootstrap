locals {

  #############
  # VPC
  #############
  vpc_name             = "${var.org}-${var.environment}-vpc"
  azs_names            = length(var.azs) == 0 ? data.aws_availability_zones.available.names : var.azs
  azs_count            = length(local.azs_names)
  public_subnet_cidrs  = [for step in range(local.azs_count) : cidrsubnet(var.vpc_cidr, 5, step)]
  private_subnet_cidrs = [for step in range(local.azs_count) : cidrsubnet(var.vpc_cidr, 5, step + local.azs_count)]

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
