output "bucket_name" {
  description = "Bucket name for our static website hosting"
  value = module.home_english_food_hosting.bucket_name
}

output "s3_website_endpoint" {
  description = "S3 Static Website hosting endpoint"
  value = module.home_english_food_hosting.website_endpoint
}

output "english_food_cloudfront_url" {
  description = "The CloudFront Distribution Domain Name for the English Food Home"
  value = module.home_english_food_hosting.domain_name
}

output "home2_cloudfront_url" {
  description = "The CloudFront Distribution Domain Name for Home 2"
  value = module.home_home2_hosting.domain_name
}