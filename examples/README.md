# Using example with terragrunt

The example show how to structure the project for using the module in multiregional multienvironment setup.
Terragrunt in this example allow us to keep the Terraform code DRY across environments

## Requirements 

* Terraform installed in version > 1.1, < 1.2 
* Terragrunt installed in version >= 0.36.0

## Usage

In `/terragrunt/dev/eu-cental-1/platform` run `terragrunt apply`