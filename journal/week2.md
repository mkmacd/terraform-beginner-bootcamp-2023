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

