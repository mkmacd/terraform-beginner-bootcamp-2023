$$ Terrahouse AWS

```tf
module "home_english_food" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  content_version = var.content_version
  assets_english_path = var.assets_english_path
  public_english_path = var.public_english_path
  css_english_path = var.css_english_path
  html_english_filepath = var.html_english_filepath
  recipes_english_path = var.recipes_english_path
}
```

The public directory expects th following
- index.html
- error.html
- assets

All top level files in assets will be copied, but not any subdirectories.

