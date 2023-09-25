# Terraform Beginner Bootcamp 2023 ***Week 1***


## Rebasing Commits

### Setting Up GitPod To Allow Rebasing

Occasionally commits need rebasing if mistakes have been made and these need to be squashed. To do this GitPod needs to be able to use VS code as it's editor and it needs an env var to be unset.
For some reason in my GitPod environment it doesn't seem to allow it.

This has been fixed by running
- `git config --global core.editor "gitpod-code --wait"`
- `unset GIT_EDITOR`

### Rebasing Commits

Run `git rebase -i main`
This brings up an editor that allows you to move around commits and put them in a different order (assuming no merge conflicts will arise)

First  env var git_editor
Then .git/config in your repository
Then ~/.gitconfig
Then /etc/gitconfig
Then VIM (if using git bash)




#### Key Git Merge Commands

- 

