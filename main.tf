terraform {
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
  region = "eu-west-2"
}
provider "random" {
  # Configuration options
}

resource "random_string" "bucket_name" {
  length           = 16
  special          = false
  upper            = false
}

output "random_bucket_name" {
  value = random_string.bucket_name.result
}

resource "aws_s3_bucket" "terraform_s3_bucket" {
  bucket = random_string.bucket_name.result

  tags = {
    Name        = "Terraform Bucket"
    Environment = "tf_bootcamp"
  }
}