############################
# VPC
############################

output "vpc_name" {
  value       = try(module.vpc[0].name, null)
  description = "The name of the VPC"
}

output "vpc_id" {
  value       = try(module.vpc[0].vpc_id, null)
  description = "The VPC ID"
}

output "vpc_public_subnets_ids" {
  value       = try(module.vpc[0].public_subnets, null)
  description = "The list of public subnets IDs associated with the VPC"
}

output "vpc_private_subnets_ids" {
  value       = try(module.vpc[0].private_subnets, null)
  description = "The list of private subnets IDs associated with the VPC"
}

output "vpc_nats_ids" {
  value       = try(module.vpc[0].nat_ids, null)
  description = "The list of allocation ID for Elastic IPs"
}

output "vpc_public_route_table_ids" {
  value       = try(module.vpc[0].public_route_table_ids, null)
  description = "The list of IDs of public route tables"
}

output "vpc_private_route_table_ids" {
  value       = try(module.vpc[0].private_route_table_ids, null)
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
  description = "The id of the cluster"
}

output "eks_cluster_name" {
  value       = module.eks.cluster_name
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

output "eks_cluster_oidc_issuer_arn" {
  value       = module.eks.oidc_provider_arn
  description = "The ARN on the EKS cluster OIDC provider"
}

output "eks_cluster_primary_security_group_id" {
  value       = module.eks.cluster_primary_security_group_id
  description = "The cluster primary security group ID created by the EKS cluster"
}

output "eks_cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "Endpoint for your Kubernetes API server"
}

output "eks_cluster_certificate_authority_data" {
  value       = module.eks.cluster_certificate_authority_data
  description = "Base64 encoded certificate data required to communicate with the cluster"
}
