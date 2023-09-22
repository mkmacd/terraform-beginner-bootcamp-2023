# Terraform Beginner Bootcamp 2023

## Semantic Versioning :mage:

This project is going to use semantic versioning for its tagging.
[sember.org](https://semver.org/)

The general format is **MAJOR.MINOR.PATCH**, eg ```1.2.3```

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes
Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

## Git Commands That Might Be Useful

| Command      | Use Case |
| ----------- | ----------- |
| git status      | Get current status of staged or untracked files      |
| git pull      | Pull from remote repository      |
| git push   | Push to remote repository|
| git add [file]| Add file to staging area|
| git commit -m "commit message here" | Create commit |
| git tag [0.0.0] | Add tag to current commit |
| git push --tags | Push tags to remote repository|
| git tag -d [0.0.0] | Delete specific tag |
| git push origin :refs/tags/[0.0.0] | Delete specific tag ***from remote***|
| git pull --tags -f | Force pull tags from remote |


## Installing Terraform CLI

### Terraform Refactoring
The terraform installation instructions have changed due to gpg keyring changes. So the original gitpod.yml bash configuration. The latest linux instructions can be found here:
[Terraform Install](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

These have been put into an executable file called [./bin/install_terraform_cli](./bin/install_terraform_cli) in the bin folder. That will run when the workspace is created and install the terraform CLI.
- This will keep the gitpod task file [gitpod.yml](.gitpod.yml) tidy.
- This will allow us easier task to debug and execute manually Terraform CLI install
- This will allow better portability for other projects that need to install Terraform CLI.

### Running *init* on Gitpod Issue

Gitpod only runs init (in .gitpod.yml) on the starting of a **new** workspace. If you start an existing workspace it will not complete init. You need to change *init* to be *before*.

[See here](https://www.gitpod.io/docs/configure/workspaces/tasks)

### Considerations for Linux Distribution

This project is built against Ubuntu.
Please consider checking your linux distribution and check if it requires and changes and edit according to your distribution needs.

[How to check OS version in linux](https://support.ucsd.edu/kb_view.do?sysparm_article=KB0032481#Linux)

```
 $ cat /etc/os-release

PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```
## Change Permissions
chmod 744 ./bin/install_terrform_cli changes the permission to allow the user to execute the file.

## Using a shebang
[Wikipedia - Shebang](https://en.wikipedia.org/wiki/Shebang_(Unix))


### Creating and Merging Branches

- Raise issue in github and create branch (in GitHub)
- `git pull`
- `git checkout <branch>` (with issue)
- fix issue
- `git commit -m <message>` (Commit fix)
- (`git tag 0.0.0`) (If tag needed)
- (`git push --tags`) (If tags added)
- `git push`
- Create pull request in GitHub
- Merge pull request  (GitHub)
- Delete branch in GitHub
- ***`checkout main`***
- `git pull -p` (deletes origin/branch name branch)
- `git branch -d <branchname>` (deletes local branch)

### If you forget to create a ticket and are working on main..

- Create ticket retrospectively
- Create branch from ticket (in GitHub)
- `git pull`
- `git add <files>`
- `git stash save`
- `git checkout <issue branch name>`
- `git stash apply`
- `git commit -m <message>` and continue as above

### Working with EN Vars
#### Env Command
We can list out all environment variables using `env`

We can filter specific env vars using grep eg `env | grep AWS_`

#### Setting and Unsetting Env Vars

In the terminal we can set using `export HELLO="world"`

We can unset using `unset HELLO`

We can sent an env var temporarily when just running a command
```
HELLO='world' ./bin/print_message
```

Within a bash script we can set an env var without writing export eg:
```sh
#!/usr/bin/env bash
HELLO='world'

echo $HELLO
```

#### Printing Env Vars

We can print env vars with echo eg `echo $HELLO`

#### Scoping Env Vars

When you open up new bash terminals in VSCode it will not be aware of env vars that you have set in another window.

If you want Env Vars to persist across all future bash terminals that are open you need to set Env Vars in your bash profile. eg. `.bash_profile`

#### Persisting Env Vars in GitPod

We cna persist env vars in gitpod by storing them in GitPod secrets storage.
```
gp env HELLO='world'
```
All future workspaces launched will se the env vars for all bash terminals opened in all workspaces.

You can also set env vars in the `.gitpod.yml` but this can only contain non sensitive variables.


## AWS CLI

```sh
aws sts get-caller-identity
```
can be used to check if our AWS credentials are configured correctly.

We need to set env vars with region, access key and secret access key. This can be retrieved from IAM in AWS console.

[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We need to set GitPod env vars using 
```sh
gp env AWS_ACCESS_KEY_ID='ABCDEFGHIJKLMNOPQRST'
gp env AWS_SECRET_ACCESS_KEY='ABCDEFGHIJKLMNOSECRET'
gp env AWS_DEFAULT_REGION=eu-west-2
```

When we then run 
```sh
aws sts get-caller-identity
```

It will return json like this:
```json
{
    "UserId": "AIDAYYGHIKGGZHNNC4CU3",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/terraform_bootcamp"
}
```

### Update to install_aws_cli

If AWS CLI is already installed when the workspace is started (eg in a restart) then it tries to install and fails. I have updated the [install_aws_cli](./bin/install_aws_cli) file to include two lines to remove the AWS CLI to prevent this:
```sh
rm -f '/workspace/awscliv2.zip'
rm -rf '/workspace/aws'
```


# Terraform

### Terraform Registry

You can access the terraform registry at [https://registry.terraform.io/](https://registry.terraform.io/)

### Basic Actions

- ***Providers*** is an interface to APIs that will allow you to create resources in terraform.
- ***Modules*** are a way to refactor or make large amounts of terraform code modular, portable and shareable.

[Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)

`terraform init` - This downloads the binaries for the terraform providers that we will use.

`terraform plan` - Shows the changes that will be made when terraform is applied. We can output this changeset (plan) to be passed to an apply, but often you can just ignore outputting.

`terraform apply` - Applies the changeset. Needs input of "yes".

`terrform apply --auto-complete` - Applies the changes without requiring a "yes" user input.

`terraform destroy` - This will destroy resources.

### Terraform Lock Files

`.terraform.lock.hcl` contains the locked versining for the providers ofr modules that should be used with this project. 

The terraform lockfile should be ***committed*** to your version control system (eg GitHub)

### Terraform State File

`.terraform.tfstate` contains information about the current stat of your infrastructutre. This ***should not*** committed to you version controlled system.

If you lose this file, you lose knowing the state of your infrastructure.

`.terraform/tfstate.backup` is the previous state file state.

### Terraform Directory

`.terraform` directory contains binaries of terraform providers.


### Issues with Terraform Cloud Login and Gitpod Workspace

When attempting to run `terraform login` it will launch bash a wiswig view to generate a token. However it does not work expected in Gitpod VsCode in the browser.

The workaround is manually generate a token in Terraform Cloud

```
https://app.terraform.io/app/settings/tokens?source=terraform-login
```

Then create open the file manually here:

```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
```

Provide the following code (replace your token in the file):

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR-TERRAFORM-CLOUD-TOKEN"
    }
  }
}
```

### Issue with using `tf plan` and Terraform Cloud

Whilst I had set the env vars within GitPod with `AWS_SECRET_ACCESS_KEY` and `AWS_ACCESS_KEY_ID` and `AWS_DEFAULT_REGION` when using Terraform Cloud these variables have to be set in the GUI of TF Cloud as well otherwise you get the error:

```
Error: No valid credential sources found
│ 
│   with provider["registry.terraform.io/hashicorp/aws"],
│   on main.tf line 21, in provider "aws":
│   21: provider "aws" {
│ 
│ Please see https://registry.terraform.io/providers/hashicorp/aws
│ for more information about providing credentials.
│ 
│ Error: failed to refresh cached credentials, no EC2 IMDS role found,
│ operation error ec2imds: GetMetadata, request canceled, context deadline
│ exceeded
│ ```

Some info can be found at [https://developer.hashicorp.com/terraform/cloud-docs/workspaces/variables/managing-variables#security](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/variables/managing-variables#security)

