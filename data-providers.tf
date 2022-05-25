data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "opt-in-status" # making sure it only return Availability Zones without Local Zones
    values = ["opt-in-not-required"]
  }
}