# Ruby Swagger

A super simple library to read or create (Swagger)[http://swagger.io/] API documents.
This is the engine used in other gems to translate API definitions (grape, rails) into Swagger definitions.

Note: Only Swagger Version 2.0 of the spec is supported.

## Install

You can install the gem as

```
gem install ruby-swagger
```

or adding it to your bundle:

```
gem 'ruby-swagger'
```

and then

```
bundle install
```

If you are using ruby-swagger inside a Grape project, make sure the ruby-swagger is defined after grape in your gemfile.
If you have problem finding the extended methods, you can manually require it with:

```
require 'ruby-swagger'
require 'ruby-swagger/grape/grape'
```

and then bundle install.

## What you get

This gem provides mostly 2 independent services for your ruby swagger documentation.

1. It provides an object-oriented implementation of the (Swagger 2.0 Specification)[https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md] This part of the gem - under swagger/data - allows you to manipulate Swagger-2.0 documents in an object-oriented way

2. A set of tasks and grape extensions to convert your grape documentation into a Swagger 2.0 documentation. Using these tasks you can:

  (a) extract, from the Grape API structure, a file system representation in YAML of your documentation. 
This is not your final documentation (yet) but, similarly to Jakyll, you can now have other parties (technical writer) editing and maintaining
your documentation in a yaml-like version. These tasks allow you to maintain the YAML version of your documentation up-to-date with the Grape definition of your API.

  (b) extend the Grape syntax of the API defining OAuth2 scopes, errors, permissions, deprecation, etc. These extensions are read by this library
and included in your documentation

  (c) compile the Swagger 2.0 documentation from the YAML version of your documentation. This is the final artifact that you can deploy
under public/ or distribute in other ways (CDN on S3)

  (d) auto generate all the API clients by running the swagger-codegen task. You can distribute the API clients on public/ or using other ways (CDN on S3?)

  (e) you can automate a+b+c+d+e in your continuous deployment so your documentation and clients are always up-to-date

## Usage

Assuming you have included the gem into your Gemfile, you should see a new swagger: namespace into your rake tasks. For example, running rake -T:

```
...
rake swagger:compile_doc                                   
[wip] rake swagger:compile_clients:...
rake swagger:grape:generate_doc[base_class]               
...
```

### Extracting the documentation from your Grape API

You can run the command

```
rake swagger:grape:generate_doc[base_class]  
```

where base_class is the root class of your API definition in Grape.
 
For example, if all your API is mounted into a "APIBase" class:
 
```
rake swagger:grape:generate_doc[base_class]  
```

will extract all the documentation from all the routes coming from that base class.

This task will create by default a new directory structure under ./doc/swagger - this directory will contain all the YAML documentation of your project.

#### YAML documentation structure

The ./doc/swagger is structured in the following way:

* ./doc/swagger/base_doc.yaml 

  This file is written only the first time you execute the rake swagger:grape:generate_doc task and never overwritten. This file contains
all the basic information for your API: the author, contact information, license, base URL, version, security schemes, format, etc.
It is equivalente to the (basic object of Swagger)[https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#swagger-object].
Once it is created is never updated by ruby-swagger tasks, so it is your duty to manually change any of the contact information, license, etc.

* ./doc/swagger/paths (folder)

  This folder contains a structure of subfolders that is 1-1 mapped with your API. Each folder represent a path component in your route.
Each file name is the verb whose that path is accessible from. The API version and API prefix is stripped when generating the file system structure.

  **Example #1**: if you have a GET API available at /api/v1/users/activity, you will have a ./doc/swagger/paths/users/activity/get.yaml file containing the documentation for that API method.
  
  **Example #2**: if you have a POST API method available at /api/v1/users, you will have a ./doc/swagger/paths/users/post.yaml file containing the documentation for that API method.

  Within each file there is the full definition of the API operation. When you execute the rake swagger:grape:generate_doc task,
some properties will be overwritten by the Grape documentation - some will not. This means you can edit the documentation from the YAML file
while the structural properties of the API are still reflecting the Grape definition.

  [WIP] The following properties are NOT overwritten by the rake task:

  * summary
  * description
  * parameters.description

  [WIP] Summary, description and parameters description accept a Markdown representation - so you can produce HTML in your swagger definition by using Markdown here.

You can check in your ./doc/swagger structure in Github and have other parties work with you on the documentation.
You can regenerate / reupdate the documentation rerunning the rake swagger:grape:generate_doc. You can have this task running as part of
your continuous deployment or have it running as post git hook.

### Extracting the documentation from your Grape API

Assuming you have generated your documentation using swagger:grape:generate_doc, you can now compile the entire documentation into a valid
Swagger 2.0 file. You can do that by running the task

```
rake swagger:compile_doc
```

This task will read all the documentation definition under ./doc/swagger/ and produce a single swagger file under ./doc/swagger/swagger.json

This is your Swagger 2.0 documentation. You can now move this file under /public (if you want to distribute it like this) or upload it
on S3, CDN, etc. This is the live definition of your API.

Each time you run the swagger:compile_doc task, the swagger.json file is regenerated (overwritten). You can check in the swagger.json file under your version control system.

### Auto generate clients

(This is WIP)


## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Submit a pull request.

## Help

If you have found a bug or you want to get in touch with us, write an email to <open@gild.com>.

