output "bucket_name" {
    description = "Bucket name for our static website hosting"
    value = module.terrahouse_aws.bucket_name
}
output "website_endpoint_s3"{
    description = "S3 static website hosting endpoint"
    value = module.terrahouse_aws.website_endpoint
}
