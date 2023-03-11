terraform {
  backend "s3" {
    bucket = "my-stage-bucket"
    key    = "vpc/terraform.tfstate"
    region = "us-west-2"
  }
}