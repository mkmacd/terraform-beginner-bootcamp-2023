# Terraform Beginner Bootcamp 2023 **Week 2**

## Working with Ruby

### Bundler

Bundler is a package manager for ruby. 
It is the primary way to install Ruby packages (known as gems) for ruby.

#### Installing gems

Yuou need to create a Gemfile and define your gems in that file.
```ruby
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```
Then you need to run the `bundle install` command.
This will install the gems on the system globally (unlike nodejs which isntall packages in place in a folder called node_modules)

A gemfile.lock will be create to lock down the gem versions being used in this project.

#### Executing ruby scripts in the context of bundler

We have to use `bundle exec` to tell future Ruby scripts to use the gem we installed. This is the way we set context.


## Working with Sinatra

Sinatra is a micro web framework for ruby to build web-apps.

It's great for mock or dev servers or for very simple projects. 

You can create a web server in a single file.

[Sinatra](https://sinatrarb.com/)

## Terratowns Mock Server

### Running the web server

We can run the web server by running the follwing commands

```ruby

bundle install
bundle exec ruby server/rb

```
All of the code for our server is stored in the `server.rb` file.


## Final issues

I was having difficult with ensuring the css worked appropriately as well as the images showing up. 

To fix this I seperated out the uploads into the main html, css, and two image uploads depeding on the folders they resided in. This enabled me to ensure `content_type ="appropriate/type`

The final blocks were as follows:

```tf
resource "aws_s3_object" "upload_top_html" {
  for_each = fileset(var.html_filepath,"*.{html}")
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "${each.key}"
  source = "${var.html_filepath}/${each.key}"
  content_type = "text/html"
  etag = filemd5("${var.html_filepath}${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}

resource "aws_s3_object" "upload_general_assets" {
  for_each = fileset(var.assets_path,"*.{jpg,png,gif,jpeg,ico,svg}")
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "assets/${each.key}"
  source = "${var.assets_path}/${each.key}"
  content_type = "image/jpeg"
  etag = filemd5("${var.assets_path}${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}

resource "aws_s3_object" "upload_recipe_assets" {
  for_each = fileset(var.recipes_path,"*.{jpg,jpeg}")
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "assets/recipes/${each.key}"
  source = "${var.recipes_path}/${each.key}"
  content_type = "image/jpeg"
  etag = filemd5("${var.recipes_path}${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}

resource "aws_s3_object" "upload_css" {
  for_each = fileset(var.css_path,"*.css")
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "css/${each.key}"
  source = "${var.css_path}/${each.key}"
  etag = filemd5("${var.css_path}${each.key}")
  content_type = "text/css"
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}
```

This also required extra path variables to be set including:

```
html_filepath="/workspace/terraform-beginner-bootcamp-2023/public/"
assets_path="/workspace/terraform-beginner-bootcamp-2023/public/assets/"
recipes_path="/workspace/terraform-beginner-bootcamp-2023/public/assets/recipes/"
public_path="/workspace/terraform-beginner-bootcamp-2023/public/"
css_path="/workspace/terraform-beginner-bootcamp-2023/public/css/"
```

When path variables are set they also need to be added to `variables.tf` within the module and at the top level like this:
```
variable "recipes_path" {
  description = "Path to recipes folder within assets"
  type        = string
}
```

As well as within the module block in  `main.tf`
```
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.teacherseat_user_uuid
  error_html_filepath = var.error_html_filepath
  index_html_filepath = var.index_html_filepath
  content_version = var.content_version
  assets_path = var.assets_path
  public_path = var.public_path
  css_path = var.css_path
  html_filepath = var.html_filepath
  recipes_path = var.recipes_path
}```


### Updates with Two Homes

This code above was updated when we changed the variables when creating two homes. The changes were using the new `var.public_path`
The new code is as follows:

```
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
```