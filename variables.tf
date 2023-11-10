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
  default     = "1.26"
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

variable "eks_default_cluster_addons" {
  description = "Map of default cluster addon configurations to enable for the cluster."
  type        = any
  default = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
      preserve          = true
      most_recent       = true
    }
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
      preserve          = true
      most_recent       = true
    }
    kube-proxy = {
      resolve_conflicts = "OVERWRITE"
      preserve          = true
      most_recent       = true
    }
  }
}

variable "eks_additional_cluster_addons" {
  description = "Map of additional cluster addon configurations to enable for the cluster."

  type    = any
  default = {}

}

variable "eks_storage_classes" {
  description = "EBS storage class with custom parameters"
  type = list(object({
    name                      = string
    storage_class_provisioner = string
    parameters                = optional(map(string))
    volume_binding_mode       = optional(string)
    reclaim_policy            = optional(string)

    }
  ))
  default = []
}

variable "eks_enable_secret_encryption" {
  description = "Should KMS key to encrypt kubernetes secrets be generated"
  type        = bool
  default     = true
}

variable "eks_single_az" {
  description = "Specifies if all node's should be deployed in the same AZ"
  type        = bool
  default     = false
}

variable "manage_aws_auth_configmap" {
  description = "Should Terraform manage aws_auth ConfigMap used for setting up cluster access"
  type        = bool
  default     = true
}

variable "create_aws_auth_configmap" {
  description = "Should Terraform create aws_auth ConfigMap used for setting up cluster access"
  type        = bool
  default     = false
}

variable "create_vpc" {
  description = "Specifies if new VPC be created, if not `vpc_id` and `subnet_ids` variables need to be provided"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "ID of existing VPC, only used when `create_vpc` is set to `false`"
  type        = string
  default     = ""
}

variable "private_subnet_ids" {
  description = "List of IDs of existing private subnets, only used when `create_vpc` is set to `false`"
  type        = list(string)
  default     = []
}

variable "public_subnet_ids" {
  description = "List of IDs of existing public subnets, only used when `create_vpc` is set to `false`"
  type        = list(string)
  default     = []
}

variable "enable_ebs_csi_driver" {
  description = "Specifies if enable the EBS/CSI driver"
  type        = bool
  default     = true
}

variable "eks_create" {
  description = "Specifies if actually create the EKS cluster"
  type        = bool
  default     = true
}
