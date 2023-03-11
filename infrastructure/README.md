# **OCTO : `aws-tf-library`**

# Requirements

Use cases the proposed structure will cover

- AWS as a cloud provider. This could also be applied to others as Terraform supports many different providers.
- AWS multi-account setup. One account for production workloads and one for testing purposes.
- Crucial resources (e.g. database) deployed manually and on-demand.
- Short-lived dynamic environments to support review apps for branches.
- Sharing and referencing resources created by other Terraform configuration.
- Frictionless local development.
- Ability to deploy from a local machine without a complex authentication flow.
- Acting in the context of a given AWS account by assuming a role.
- Terraform states stored on a separate utility AWS account.

# Context

Resources are assigned to a given environment:

- **prod** (production)
- **pre** (pre-production/staging). An environment for testing purposes. Acts as a gate before the production. Mirrors the production environment.
- **rev** (review). Dynamic short-lived environments. Spin up on demand. We can have many of them. Mimics the pre-production environment.

# proposed directory structure

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

Local Machine Deployment

```bash
$ cd infrastructure/environments/pre
$ terraform init
$ terraform apply
$ cd ../../../infrastructure/environments/pro
$ terraform init
$ terraform apply
```

