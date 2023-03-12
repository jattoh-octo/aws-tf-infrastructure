# **OCTO-Ops + `Terraform`**

- The concept was created by WeaveWorks. Here is the [founding post file](https://www.weave.works/blog/gitops-operations-by-pull-request) and here is [an update](https://www.weave.works/blog/what-is-gitops-really).

- **Infrastructure as Code** : We define declaratively our **infrastructure using terraform**. 

- **Manual operations via `ssh` are prohibited**. Everything must be **done declaratively** and stored in a **git repository**.  **Git is our only source of truth**.

- Since we do not make any manual changes, we can easily **replicate our deployments**. We are talking about **immutable deployments** or **immutable infrastructure**.

- The Infrastructure as Code is managed in a git repository, so we have a **clear history** of evolutions with the **different commits and the log messages**. It also **facilitates rollbacks**.

  Manage the **content and infrastructure** of a website in a git monorepo. **Deploy automatically** with each push.

![img](/Users/jeffreyattoh/Library/CloudStorage/OneDrive-ZDAPT/OCTO/tf-iac/aws-tf-library/infrastructure/architecture.svg)

