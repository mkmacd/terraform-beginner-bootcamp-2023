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
- 

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
