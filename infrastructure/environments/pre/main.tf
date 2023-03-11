module "vpc" {
  source = "github.com/myorg/my-vpc?ref=v1.0.8"

  name       = "stage"
  cidr_block = "10.0.0.0/16"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}