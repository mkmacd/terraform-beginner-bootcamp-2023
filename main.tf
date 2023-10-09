terraform {
   required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
  cloud {
    organization = "mike_macdonald"
    workspaces {
      name = "terra-house-1"
    }
  }
}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}



module "home_english_food_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.english_food.public_path
  content_version = var.english_food.content_version
}

resource "terratowns_home" "home" {
  name = "Why English food doesn't suck!"
  description = <<DESCRIPTION
For some reason Americans think that English food is bland and tasteless! This home is filled with British Recipes to try and remedy that misconception!
DESCRIPTION
  domain_name = module.home_english_food_hosting.domain_name
  town = "cooker-cove"
  content_version = var.english_food.content_version
}


module "home_home2_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.home2.public_path
  content_version = var.home2.content_version
}


resource "terratowns_home" "home2" {
  name = "2nd Home "
  description = <<DESCRIPTION
Since I've been told to make a second home but I've got very few gitpod credits left, I'm going to do the bare minimum.... Sorry Andrew.
DESCRIPTION
  domain_name = module.home_home2_hosting.domain_name
  town = "missingo"
  content_version = var.home2.content_version
}
