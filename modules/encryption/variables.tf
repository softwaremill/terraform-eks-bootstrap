############################
# General
############################

variable "org" {
  description = "Organization name - part of other resource names"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Additional tags to include"
  type        = map(string)
  default     = {}
}