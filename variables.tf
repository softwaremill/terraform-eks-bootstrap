############################
# General
############################

variable "region" {
  default = "eu-central-1"
}

variable "org" {
  description = "Organization name - part of other resource names"
  type        = string
  default     = "terraform"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "additional_tags" {
  description = "Additional tags to include"
  type        = map(string)
  default     = {}
}

############################
# Network
############################

variable "vpc_cidr" {
  description = "VPC CIDR address"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_nat_setting" {
  description = "Enable NAT Gateway"
  type = object({
    enable_nat_gateway : bool
    multi_az_nat_gateway : bool
  })
  default = {
    enable_nat_gateway   = true
    multi_az_nat_gateway = false
  }
}

variable "logs_retention_days" {
  description = "Log retention in days"
  type        = number
  default     = 14
}

variable "enable_bastion" {
  description = "True if bastion host should be created"
  type        = bool
  default     = false
}

############################
# Kubernetes
############################

variable "eks_cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
  default     = "eks-cluster"
}

variable "eks_cluster_version" {
  description = "Kubernetes cluster version"
  type        = string
  default     = "1.22"
}

variable "eks_cluster_log_types" {
  description = "A list of the desired control plane logs to enable"
  type        = list(string)
  default     = ["api", "audit", "authenticator"]
}

variable "eks_cluster_endpoint_access" {
  description = "EKS managed node group default configurations"
  type = object({
    enable_public_access : bool
    enable_private_access : bool
  })
  default = {
    enable_public_access  = true
    enable_private_access = false
  }
}

variable "eks_cluster_node_groups_default_configuration" {
  description = "EKS managed node group default configurations"
  type        = any
  default = {
    disk_size                             = 40
    instance_types                        = ["m5.large"]
    attach_cluster_primary_security_group = true
    min_size                              = 1
    max_size                              = 5
    desired_size                          = 3
    labels = {
      "node-group" = "default"
    }
  }
}

variable "eks_cluster_node_groups" {
  description = "EKS managed additional node group"
  type        = any
  default     = {}
}

variable "eks_cluster_fargate_profiles" {
  description = "EKS Fargate profile object"
  type        = map(object({}))
  default     = {}
}

variable "eks_cluster_auth_user" {
  description = "AWS users with access permission to EKS cluster"
  type = list(object({
    userarn : string
    username : string
    groups = list(string)
  }))
  default = []
}

variable "eks_cluster_auth_role" {
  description = "AWS roles with access permission to EKS cluster"
  type = list(object({
    rolearn : string
    username : string
    groups = list(string)
  }))
  default = []
}