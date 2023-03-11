# octo-consulting-tf
This is a collection of reusable Terraform components and blueprints for provisioning reference architectures.

## Introduction
In this repo you'll find real-world examples of how we've implemented various common patterns using our terraform modules for our customers.

The component catalog captures the business logic, opinions, best practices and non-functional requirements.

It's from this catalog that other developers in your organization will pick and choose from anytime they need to deploy some new capability.


## Using pre-commit Hooks

This repository uses pre-commit and pre-commit-terraform to enforce consistent Terraform code and documentation. This is accomplished by triggering hooks during git commit to block commits that don't pass checks (E.g. format, and module documentation). You can find the hooks that are being executed in the .pre-commit-config.yaml file.

You can install pre-commit and this repo's pre-commit hooks on a Mac machine by running the following commands: