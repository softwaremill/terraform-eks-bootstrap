variable "names_suffix" {
  type        = string
  description = "The suffix added to all resource names to make it random. Used in tests."
}
variable "region" {
  type        = string
  default     = "eu-west-1"
  description = "AWS region where resources will be created."
}
