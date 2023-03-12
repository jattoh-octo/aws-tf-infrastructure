# **OCTO : `aws-tf-library`**



# Requirements

Use cases the proposed structure will cover

- AWS as a cloud provider. This could also be applied to others as Terraform supports many different providers.
- AWS multi-account setup. One account for production workloads and one for testing purposes.
- Crucial resources (e.g. database) are deployed manually and on demand.
- Short-lived dynamic environments to support review apps for branches.
- Sharing and referencing resources created by other Terraform configurations.
- Frictionless local development.
- Ability to deploy from a local machine without a complex authentication flow.
- Acting in the context of a given AWS account by assuming a role.
- Terraform states are stored on a separate utility AWS account.

# Context

Resources are assigned to a given environment:

- **prod** (production)
- **pre** (pre-production/staging). An environment for testing purposes. Acts as a gate before the production. Mirrors in the production environment.
- **rev** (review). Dynamic short-lived environments. Spin up on demand. We can have many of them. Mimics the pre-production environment.

# Terraform Directory Structure

```bash
infrastructure/
├── environments/
│   ├── prod/
│   │   ├── config.tf
│   │   └── vpc/
│   │       ├── main.tf
│   │       ├── output.tf
│   │       ├── variables.tf
│   │       └── config.tf
│   ├── pre/
│   │   ├── config.tf
│   │   └── vpc/
│   │       ├── main.tf
│   │       ├── output.tf
│   │       ├── variables.tf
│   │       └── config.tf
│   └── rev/
│       ├── config.tf
│       └── vpc/
│           ├── main.tf
│           ├── output.tf
│           ├── variables.tf
│           └── config.tf
└── modules/
    ├── vpc/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── eks/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    └── rds/
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```

*Modules are reusable Terraform configurations that can be called and configured by other configurations.*

Local Machine Deployment

```bash
$ cd infrastructure/environments/pre
$ terraform init
$ terraform apply
$ cd ../../../infrastructure/environments/pro
$ terraform init
$ terraform apply
```

## Exploration

Going deeper into the `infrastructure` folder, you will find `environments` and `modules`*.* Inside `each environment`, we have a separate directory for each environment. In `modules`, you will find Terraform modules imported by at least two environments (DRY 😉). DRY = Dont Repeat Yourself

The essence** of this approach and the thing that defines why this approach is so great. You could be tempted to use a configuration-driven approach where you have one Terraform configuration, but depending on the input, it generates different results. If you have three similar environments (pre, pro, rev), why not create one Terraform module and control it with a configuration stored in a *json* file? This idea can be influenced by the config chapter from the Twelve-Factor App methodology, but it relates to an app code (environment-agnostic), not an infrastructure code (it basically describes environments). This is what the deployment of **pre** environment could look like.

```
$ terraform apply -var-file="pre.tfvars.json"
```

If you would use a configuration-driven approach, you will sooner or later end up with many conditional statements and other bizarre hacks. Terraform is a tool intended to create declarative descriptions of your infrastructure, so please do not introduce imperativeness. By preparing separate Terraform modules for each environment, we see things how they look in reality. We have a direct, explicit mapping between code and a Terraform state. We limit WTFs/minute. The proposed solution will have more lines of code but still leave space for code reuse. Don’t forget about the modules!

## Supplementary AWS account

How is it possible that I don’t need to reauthenticate (or change a value of `AWS_PROFILE`*)* when I am switching a context of AWS accounts?

```
$ cd infrastructure/environments/pre
$ terraform apply 
# Resources deployed on test AWS account
$ cd ../../../infrastructure/environments/pro
$ terraform apply
# Resources deployed on production AWS account
# And it just works
```

In `config.tf` of any root module, you will find the following part:

This part is responsible for assuming a role. This approach is described in Terraform’s guide [Use AssumeRole to Provision AWS Resources Across Accounts. The idea of assuming is pretty simple. It allows AWS account **A** to act in the context of AWS account **B.** In our case, it allows the **bastion** account to act in the context of **production** or **test** AWS account. What is a bastion account? I will cover it in another article in more detail. For now, you just need to know that we are using this account to centralize the management of IAM permissions, storing of state files, and locks stable. To provision with Terraform, you need an IAM user, an S3 bucket, and a DynamoDB table. You will face a chicken or the egg dilemma. We decided to move this part to a separate AWS account (bastion). It allows us (in theory) to recreate all the resources on a given AWS account just by running Terraform.

![img](https://miro.medium.com/v2/resize:fit:1400/1*rDWIjiT_1M8YAUfrMMIGjw.jpeg)

## Holy Trinity… and `config.tf`

```
.
└── infrastructure
    └── environments
        └── pro
            ├── config.tf
            ├── main.tf
            ├── outputs.tf
            └── variables.tf
```

Every root module consists of 4 files, no more, no less. Each has its clearly specified role.

- `config.tf`*.* To not introduce noise at the top of the `main.tf` file, we decided to move the configuration of the backend and providers to a separate file.
- `main.tf`. Here, you will find definitions of all the resources managed by a module.
- `outputs.tf`. Set of module’s outputs. You can consume them further in shell scripts or reference them in the parent module.
- `variables.tf`. Set of modules inputs. For each value, we always specify the *description* argument for self-documenting purposes. Think of them as public class fields, whereas the values defined in the *local* block are private.

## Porcelain components

There are some situations where you do not want to give control over your resources to automated scripts in your CI/CD pipeline. Can you think of any? Often, it is a **database**. Who knows what can happen when you push on master 🤷? All of us know stories where a database suddenly went down: Because an upgrade of an engine version or type of an instance has been triggered. Therefore, sometimes you would like to deploy changes on demand and from your local machine in front of the eyes of a whole team. Let’s see what that might look like in practice.

Below is our structure.

```
.
└── infrastructure
    └── environments
        └── pro
            ├── config.tf
            ├── db
            │   ├── config.tf
            │   ├── main.tf
            │   ├── outputs.tf
            │   └── variables.tf
            ├── main.tf
            ├── outputs.tf
            └── variables.tf
```

Provisioning of **pro** resources using a command line.

```
$ cd infrastructure/environments/pro
$ terraform apply
# All resources except a database have been deployed
$ cd db
$ terraform apply 
# Only a database has been deployed
```

## Dynamic environments

Have you heard about review apps? It is a strategy of deploying an app for a git branch’s lifespan. Let’s say you are working on some feature and you want to give the ability for your PM or other devs to test them before merging to master and without asking them to spin a local environment. If you have a serverless setup, it won’t cost you almost anything as you pay for usage, not for deployed resources per se. In the repository, you will find a `.travis.yml `file where you can find how to apply this strategy. The idea is simple. For each commit on the feature branch, you provision an environment that mirrors the **pre** environment. This is the perfect use case for Terraform workspaces! From [their docs](https://www.terraform.io/language/state/workspaces#when-to-use-multiple-workspaces):

> \- A common use for multiple workspaces is to create a parallel, distinct copy of a set of infrastructure in order to test a set of changes before modifying the main production infrastructure.
>
> \- Non-default workspaces are often related to feature branches in version control.

What does it look like in practice? Take a look at the `main.tf` file in the `rev` directory. We basically just import and use the `pre` module. As we will have many different environments on the same AWS accounts (as **pre** and **rev** environments are deployed on the test AWS account), we need to distinguish them somehow. We can tag them and append a prefix to resource names.

Provisioning and destroying review environments can be easily done from CLI.

```
$ cd infrastructure/environments/rev
$ terraform init# To provision them# Review app named foo-1
$ terraform workspace new foo-1
$ terraform apply# Review app named bar-2
$ terraform workspace new bar-2
$ terraform apply# To destroy them# Review app named foo-1
$ terraform workspace select foo-1
$ terraform destroy
$ terraform workspace delete foo-1# Review app named bar-2
$ terraform workspace select bar-2
$ terraform destroy
$ terraform workspace delete bar-2
```

## Sharing and referencing

In the presented architecture, we have one topic which broadcasts events to many consumers. Consumers are in different environments. We have a common part for each of them. Sound familiar? Again, quite a common scenario for which we need to be prepared.

Where should you put such resources? On pro-environment? In CI/CD, you preferably would deploy pre-environment before **pro.** If **pre** has a dependency in the form of **pro**, it can break for a couple of minutes until the whole process of deployment finishes. This dependency is also quite hidden. To tackle this problem can create an artificial common environment, which we called **com.** That environment is always deployed as a first. To reference resources created by **com** in **pre** or **pro**, you just read the output values (do you remember the `outputs.tf` file?) of the `com` module. The values are stored in a remote state.

# Summary

All of the tips that I showed you have been battle-tested in real-case scenarios and in production environments. With them, you will be able to tame most scenarios. Use them as an inspiration to create solutions that will suit your needs.

