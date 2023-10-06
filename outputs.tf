
output "website_endpoint_s3"{
    description = "S3 static website hosting endpoint"
    value = module.terrahouse_aws.website_endpoint
}
output "cloudfront_url"{
    description = "Domain name for cloudfront distribution"
    value = module.terrahouse_aws.cloudfront_url
    }


