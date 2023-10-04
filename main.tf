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
  endpoint = "https://terratowns.cloud/api"
  user_uuid="07e7caa5-671d-481a-b140-c98fd596b1b9" 
  token="c688faa5-77c0-482b-aa24-5995897230be"
}

# module "terrahouse_aws" {
#   source = "./modules/terrahouse_aws"
#   user_uuid = var.user_uuid
#   bucket_name = var.bucket_name 
#   error_html_filepath = var.error_html_filepath
#   index_html_filepath = var.index_html_filepath
#   content_version = var.content_version
#   assets_path = var.assets_path
# }

resource "terratowns_home" "home" {
  name = "Why English food doesn't suck!"
  description = <<DESCRIPTION
American's for some reason think that English food is bland and tasteless! This home is filled with British Recipes to try and remedy that misconception!
DESCRIPTION
  #domain_name = module.terrahouse_aws.cloudfront_url
  domain_name = "3fdq3gz.cloudfront.net"
  town = "missingo"
  content_version = 1
}

