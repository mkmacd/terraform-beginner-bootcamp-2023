# Terraform Beginner Bootcamp 2023 ***Week 1***


## Rebasing Commits

### Setting Up GitPod To Allow Rebasing

Occasionally commits need rebasing if mistakes have been made and these need to be squashed. To do this GitPod needs to be able to use VS code as it's editor and it needs an env var to be unset.
For some reason in my GitPod environment it doesn't seem to allow it.
The order it looks for a text editor is:
1. env var git_editor
2. .git/config in your repository
3. ~/.gitconfig
4. /etc/gitconfig
5. VIM (if using git bash)

This has been fixed by running
- `git config --global core.editor "gitpod-code --wait"`
- `unset GIT_EDITOR`

### Rebasing Commits

#### Basic Rebasing

- `git checkout A`
- `git checkout B`
![rebasing_git](https://github.com/mkmacd/terraform-beginner-bootcamp-2023/assets/134923802/65cd2faf-a1d5-4116-baa9-5220283ce8df)


#### Key Git Merge Commands

Run `git rebase -i main`
This brings up an editor that allows you to move around commits and put them in a different order and squash them (assuming no merge conflicts will arise)

- p, pick <commit> = use commit
- r, reword <commit> = use commit, but edit the commit message
- e, edit <commit> = use commit, but stop for amending
- s, squash <commit> = use commit, but meld into previous commit
- f, fixup [-C | -c] <commit> = like "squash" but keep only the previous
                   commit's log message, unless -C is used, in which case
                   keep only this commit's message; -c is same as -C but
                   opens the editor
- x, exec <command> = run command (the rest of the line) using shell
- b, break = stop here (continue rebase later with 'git rebase --continue')
- d, drop <commit> = remove commit
- l, label <label> = label current HEAD with a name
- t, reset <label> = reset HEAD to a label
- m, merge [-C <commit> | -c <commit>] <label> [# <oneline>]
        create a merge commit using the original merge commit's
        message (or the oneline, if no original merge commit was
        specified); use -c <commit> to reword the commit message
- u, update-ref <ref> = track a placeholder for the <ref> to be updated
                      to this position in the new commits. The <ref> is
                      updated at the end of the rebase

## Root Module Structure

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

Our root module structure is as follows.
```
PROJECT ROOT
  |-- main.tf (everything else)
  |-- variables.tf         (stores the structure of input variables)        
  |-- providers.tf         (defined required providers and their configuration)
  |-- outputs.tf           (stores our outputs)
  |-- terraform.tfvars     (the data of variables we want to load into our TF project)
  |-- README.md            (required for moot modules)
```

## Terraform and Input Variables

### Terraform Cloud Variables

In terraform we can set two types of variables
- Environment Variables - Those that younwould set in your bash terminal, eg AWS credentials
- Terraform Variables - Those that you would normally set in your rfvars file

We can set TF Cloud variables to be sensitive so they're not shown visibly in the UI.

### Loading TF variables

#### Var Flag
We can use the `-var` flag to se the input variable or override a variable in the tfvars file eg. `terraform -var user_uuid="my-user-id"`

#### var-file flag
- TODO: Research this flag

#### terraform.tfvars

This is the default file to load in TF variable in bulk.


#### auto.tfvars
- TODO: document this functionality for TF cloud

#### Order of TF variables

- TODO: Document which TF variable settings take precedence

[Variables Documentation](https://developer.hashicorp.com/terraform/language/values/variables)



## Dealing with Configuration Drift

### What happens if we lose our state file?

If we lose our statefile we most likely have to tear down all our cloud infrastructure manually.

You can use terraform import but it won't work for all cloud resources. You need to check the terraform providers documentation for which resources support import.


### Fix missing resources with Terraform Import


`terraform import aws_s3_bucket.example`

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)
[AWS S3 Bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)


### Fix manual configuration

If someone goes and deletes or modifies cloud resources manually through clickops, if we run `terraform plan` again it will attempt to put our infrastructure back in it's expected state, fixing configuration drift.

### Fix using terraform refresh
```sh
terraform apply -refresh-only -auto-approve
```
## Fix using Terraform Refresh

[Terraform Refresh](https://developer.hashicorp.com/terraform/cli/commands/refresh)
```sh
terraform apply -refresh-only -auto-approve
```

## Terraform Modules

### Module Sources
Using the source, we can import the module from various places:
- locally (shown)
- github 
- terraform registry

```tf
module "terrahouse_aws"{
  source = "./modules/terrahouse_aws"
}
```

[Module Sources](https://developer.hashicorp.com/terraform/language/modules/sources)

### Passing input variables

We can pass input variables to our module. The module has to declare these tf variables in its ***own*** `variables.tf`
```tf
module "terrahouse_aws"{
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```
### Terraform Module Structure

It is recommend to place modules in a modules directory when developing modules but it can be named whatever you like.


## Considerations When using ChatGPT to write Terraform

LLMs such as ChatGPT may not be trained on the latest documentation or information about terraform so it may likely produce older examples that could be deprecated, often affecting providers.

## Working with files in terraform

### Fileexists function

This is a built in terraform function to check the existence of a file.
```
variable "index_html_filepath" {
  description = "The filepath for index.html"
  type = string
  
  validation {
    condition = fileexists(var.index_html_filepath)
    error_message = "The provided path for index.html does not exist."
  }
}
```

### Filemd5

As terraform doesn't store the content of a file, if a file is update terraform doesn't know. You can use filemd5 to create a has of the file, so anytime the file is update this hash changes so terraform knows to update it. This uses an **etag**

```
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = var.index_html_filepath
  etag = filemd5(var.index_html_filepath)
}
```

### Path Variable

In terraform there is a special variable called path that allows us to reference local paths.
- path.module - get the path for the current module
- path.root - get the path for the root module


[Special Path Reference](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

```
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html
}
```

### Terraform Data Sources


This allows us to source data from cloud resources.

This is useful when we want to reference cloud resources without importing them.

```tf
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

### Terraform Locals

This is a way for us to reference local variables.
A local value assigns a name to an expression, so you can use the name multiple times within a module instead of repeating the expression.

[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

### Working with JSON

We use `jsonencode` to create the json polilcy to create the json policy inline in the hcl.

```json
> jsonencode({"hello"="world"})
{"hello":"world"}
```
[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)


### Changing the Lifecycle of resources

Sometimes you don't want everything to deploy when you make individual changes, eg to a website. You might want to do it with content version (almost like major release)
As we have etags in our `aws_s3_object` resource, this tells terraform any time there's a change with the files in it.
We can add lifecycle and force it to ignore the changes to the file using:
```
lifecycle {
    ignore_changes = [etag]
  }
  ```

  ### Terraform Data

We need to create a "fake" resource that can be referenced:
```
resource "terraform_data" "content_version" {
  input = var.content_version
  }
  ```

  The update the lifecycle with:

  ```
  lifecycle {
    replace_triggered_by = [var.terraform_data.content_version.output]
    ignore_changes = [etag]
  }
  ```

  This will look at the changes to the content version and not the changes to the file.


[Meta arguments lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle) 

In the top level variables file we put
```
variable "content_version" {
  type        = number
}
```

Within variables in the terrahouse module we put:
```
variable "content_version" {
  description = "The content version. Should be a positive integer starting at 1."
  type        = number

  validation {
    condition     = var.content_version > 0 && floor(var.content_version) == var.content_version
    error_message = "The content_version must be a positive integer starting at 1."
  }
}
```

In the top level main.tf we update to:
```
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name 
  error_html_filepath = var.error_html_filepath
  index_html_filepath = var.index_html_filepath
  content_version = var.content_version
}
```

Then in the top level `terraform.tfvars` file we add `content_version=2` (and this is what we change.)


## Provisioners 

Provisioners allow you to to execute commands on compute instances. Eg an AWS CLI command. They're not recommended for use by Hashicorp because configuration management tools such as Ansible area a better fit but the functionality exists

### Local-exec

This will execute a command on the machine running the terraform commands, eg plan apply

### Remote-exec

This will execute commands on a machine that wyou will tartget. You will need to provide credentials such as ssh to get into the machine.

[Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

[Remote Exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec)
For example
```tf
resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}

```