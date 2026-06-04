provider "aws" {
  region = var.AWS_REGION
}

terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "m2c-tn-terraform-state"
    key     = "move2cloud.tn/github-oidc/terraform.tfstate"
    region  = "eu-west-3"
    encrypt = true
  }
}
