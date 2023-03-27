# Set region-specific variables. They are automatically
# pulled in to the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
    aws_region = "us-east-1"
}