terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# AWS provider compatible with LocalStack by default.
# Credentials should come from environment variables or OIDC (GitHub Actions), not from Terraform variables.
provider "aws" {
  region                      = var.region
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  # When running against LocalStack, set var.localstack_endpoint to e.g. "http://localhost:4566"
  endpoints {
    s3    = var.localstack_endpoint
    ssm   = var.localstack_endpoint
    ecs   = var.localstack_endpoint
    iam   = var.localstack_endpoint
    elbv2 = var.localstack_endpoint
    logs  = var.localstack_endpoint
  }
}
