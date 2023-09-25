resource "random_string" "bucket_name" {
  length           = 16
  special          = false
  upper            = false
}



resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name

  tags = {
    UserUID       = var.user_uuid
   }
}