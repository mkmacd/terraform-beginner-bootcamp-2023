terraform {
  # cloud {
  #   organization = "mike_macdonald"
  #   workspaces {
  #     name = "terra-house-1"
  #   }
  # }
  # required_providers {
  #   random = {
  #     source = "hashicorp/random"
  #     version = "3.5.1"
  #   }
     
  # }
}

module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name 
}