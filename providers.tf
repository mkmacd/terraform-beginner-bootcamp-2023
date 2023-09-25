terraform {
  # cloud {
  #   organization = "mike_macdonald"
  #   workspaces {
  #     name = "terra-house-1"
  #   }
  # }
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
     aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
     }
  }
}


provider "aws" {
}

provider "random" {
  # Configuration options
}