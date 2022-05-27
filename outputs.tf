############################
# VPC
############################

output "vpc_name" {
  value       = module.vpc.name
  description = "The name of the VPC"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The VPC ID"
}

output "vpc_public_subnets_ids" {
  value = module.vpc.public_subnets

  description = "The list of public subnets IDs associated with the VPC"
}

output "vpc_private_subnets_ids" {
  value       = module.vpc.private_subnets
  description = "The list of private subnets IDs associated with the VPC"
}

output "vpc_nats_ids" {
  value       = module.vpc.nat_ids
  description = "The list of allocation ID for Elastic IPs"
}

output "vpc_public_route_table_ids" {
  value       = module.vpc.public_route_table_ids
  description = "The list of IDs of public route tables"
}

output "vpc_private_route_table_ids" {
  value       = module.vpc.private_route_table_ids
  description = "The list of IDs of private route tables"
}


############################
# EKS
############################

output "eks_cluster_arn" {
  value       = module.eks.cluster_arn
  description = "ARN of the cluster"
}

output "eks_cluster_id" {
  value       = module.eks.cluster_id
  description = "The name of the cluster"
}

output "eks_cluster_version" {
  value       = module.eks.cluster_version
  description = "The Kubernetes server version for the EKS cluster."
}

output "eks_cluster_oidc_issuer_url" {
  value       = module.eks.cluster_oidc_issuer_url
  description = "The URL on the EKS cluster OIDC Issuer"
}


output "eks_cluster_primary_security_group_id" {
  value       = module.eks.cluster_primary_security_group_id
  description = "The cluster primary security group ID created by the EKS cluster"
}