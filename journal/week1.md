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


### Fix missing resources with Terraform Import

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)


### Fix manual configuration

If someone goes and deletes or modifies cloud resources manually through clickops, if we run `terraform plan` again it will attempt to put our infrastructure back in it's expected state, fixing configuration drift.
