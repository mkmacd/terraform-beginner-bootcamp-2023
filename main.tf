terraform {
   required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
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

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}

module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.teacherseat_user_uuid
  error_html_filepath = var.error_html_filepath
  index_html_filepath = var.index_html_filepath
  content_version = var.content_version
  assets_path = var.assets_path
}

resource "terratowns_home" "home" {
  name = "Why English food doesn't suck!"
  description = <<DESCRIPTION
Americans, for some reason think that English food is bland and tasteless! This home is filled with British Recipes to try and remedy that misconception!
DESCRIPTION
  domain_name = module.terrahouse_aws.cloudfront_url
  town = "missingo"
  content_version = 1
}

