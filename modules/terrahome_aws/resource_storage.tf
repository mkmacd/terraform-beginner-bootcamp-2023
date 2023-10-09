resource "aws_s3_bucket" "website_bucket" {
  # We want to assign a random bucket name
  #bucket = var.bucket_name
  tags = {
    UserUID       = var.user_uuid
   }
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration
resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
# resource "aws_s3_object" "index_html" {
#   bucket = aws_s3_bucket.website_bucket.bucket
#   key    = "index.html"
#   source = var.index_html_filepath
#   etag = filemd5(var.index_html_filepath)
#   content_type = "text/html"
#   lifecycle {
#     ignore_changes = [etag]
#     replace_triggered_by = [terraform_data.content_version.output]
#   }
# }

# resource "aws_s3_object" "error_html" {
#   bucket = aws_s3_bucket.website_bucket.bucket
#   key    = "error.html"
#   source = var.error_html_filepath
#   etag = filemd5(var.error_html_filepath)
#   content_type = "text/html"
#   lifecycle {
#     replace_triggered_by = [terraform_data.content_version.output]
#     ignore_changes = [etag]
#   }
# }

resource "aws_s3_object" "upload_top_html" {
  for_each = fileset(var.public_path,"*.{html}")
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "${each.key}"
  source = "${var.public_path}/${each.key}"
  content_type = "text/html"
  etag = filemd5("${var.public_path}/${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}

resource "aws_s3_object" "upload_general_assets" {
  for_each = fileset("${var.public_path}/assets","*.{jpg,png,gif,jpeg,ico,svg}")
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "assets/${each.key}"
  source = "${var.public_path}/assets/${each.key}"
  content_type = "image/jpeg"
  etag = filemd5("${var.public_path}/assets/${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}

resource "aws_s3_object" "upload_recipe_assets" {
  for_each = fileset("${var.public_path}/assets/recipes","*.{jpg,jpeg}")
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "assets/recipes/${each.key}"
  source = "${var.public_path}/assets/recipes/${each.key}"
  content_type = "image/jpeg"
  etag = filemd5("${var.public_path}/assets/recipes/${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}

resource "aws_s3_object" "upload_css" {
  for_each = fileset("${var.public_path}/css","*.css")
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "css/${each.key}"
  source = "${var.public_path}/css/${each.key}"
  etag = filemd5("${var.public_path}/css/${each.key}")
  content_type = "text/css"
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}





# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.bucket
  #policy = data.aws_iam_policy_document.allow_access_from_another_account.json
  policy = jsonencode(
    {
    "Version" = "2012-10-17",
    "Statement" ={
        "Sid"= "AllowCloudFrontServicePrincipalReadOnly",
        "Effect"= "Allow",
        "Principal"= {
          "Service"= "cloudfront.amazonaws.com"
        },
        "Action"= "s3:GetObject",
        "Resource"= "arn:aws:s3:::${aws_s3_bucket.website_bucket.id}/*",
        "Condition"= {
          "StringEquals"= {
            "AWS:SourceArn"= "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
            # "AWS:SourceArn"= aws_cloudfront_distribution.s3_distribution.arn 
          }
        }
    }
})
}

resource "terraform_data" "content_version" {
  input = var.content_version
  }

