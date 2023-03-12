## Architecture Overview

As a “DevOps Accelerator”, we have a very prescriptive approach to implementing architectures on AWS.

A typical architecture consists of 4 layers that combined to establish your foundation, built from the bottom up to support your specific business requirements. It's like buying and tailoring a suit based on your specific requirements. Each pillar implements a foundation for your team to build on top of. There will likely be some “last mile” customizations needed to suit your use cases; we'll do our best to accommodate them and work with you until those needs are met.

## Pillars

five pillars of well-built infrastructure. The AWS Well-Architected framework inspires them

# Foundational Infrastructure - Landing Zone

Our foundational infrastructure consists of everything related to your AWS organization such as organizational units and Cloud Trails, IAM architecture, DNS architecture, and all the way up to the VPC and the associated VPC architecture. Everything is built with multi-region and multi-tenancy in mind since many of our customers serve enterprise businesses with complex regulatory requirements that require account-level isolation.



![foundational infrastructure](/Users/jeffreyattoh/Library/CloudStorage/OneDrive-ZDAPT/OCTO/tf-iac/aws-tf-library/images/foundational infrastructure.png)

# Foundational Platform

Your [foundational platform](https://cloudposse.com/reference-architecture/foundational-infrastructure/) is how you consistently deliver your applications. We support two popular options, including [Kubernetes](https://cloudposse.com/glossary/kubernetes/) using EKS and ECS. As part of this pillar, we deploy all the backing services required by the platform. For Kubernetes, these are services like the `amazon-load-balancer-controller`, `cert-manager`, `external-dns` and more. For ECS, we'll typically provision public and private ECS clusters along with a public and private ALB and API Gateway.

# Foundational Release Engineering

[Release Engineering](https://cloudposse.com/reference-architecture/foundational-release-engineering/) is how teams build and release their software. It's arguably the most crucial part of the entire process because it's how the business can deliver software faster and more reliably to its customers. We can deliver multiple [CI](https://cloudposse.com/glossary/continuous-integration/) and [CD](https://cloudposse.com/glossary/continuous-delivery/) patterns with a solid foundation and platform. Leveraging GitHub Actions we develop patterns for application archetypes (e.g. Dockerized Microservices, Single Page Applications, Application Libraries, Executables, etc). Then help roll those out by leveraging tools like `cookiecutter` to make it very easy to onboard new applications.

# Foundational SRE

The foundation of [Site Reliability Engineering (SRE)](https://cloudposse.com/reference-architecture/foundational-sre/) is implementing an architecture that supports observability, alerting, and incident management. As part of this process, we implement a comprehensive incident management architecture leveraging Datadog and OpsGenie, managed entirely with Terraform.

# Foundational Security and Compliance

[Our approach to security and compliance](https://cloudposse.com/reference-architecture/foundational-security-and-compliance/) at a high level is very simple. We provision all the AWS security-oriented products that enable continuous checks for compliance such as SecurityHub, GuardDuty, Inspector, and Macie. Then deploy the guardrails to ensure you're services are running securely. We work with your team to remediate all the issues raised and satisfy the auditors by deploying Audit Manager for evidence collection.