locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("regional.hcl"))

  org         = "sml"
  environment = local.environment_vars.locals.environment
  region      = local.region_vars.locals.region
}

generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = ">=1.3"
}
EOF
}

generate "provider" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {

  region = "${local.region}"
  default_tags {
    tags = {
      environment = "${local.environment}"
      createdBy   = "terragrunt"
    }
  }

}
EOF
}


inputs = {
  org         = local.org
  environment = local.environment
  region      = local.region
}