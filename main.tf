resource "random_string" "bucket_name" {
  length           = 16
  special          = false
  upper            = false
}



resource "aws_s3_bucket" "terraform_s3_bucket" {
  bucket = random_string.bucket_name.result

  tags = {
    UserUID       = var.user_uuid
   }
}