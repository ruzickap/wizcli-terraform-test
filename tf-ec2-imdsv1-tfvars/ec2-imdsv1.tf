# Description: This Terraform configuration creates EC2 instance that use IMDSv1.

# Expected result: Instance should be flagged as non-compliant because it is configured to use IMDSv1.

# Example Output:

## Checkov

# ...
# Check: CKV_AWS_79: "Ensure Instance Metadata Service Version 1 is not enabled"
# 	FAILED for resource: aws_instance.bad_instance_4
# 	File: /ec2-imdsv1.tf:42-50
# 	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-general-policies/bc-aws-general-31

# 		42 | resource "aws_instance" "bad_instance_4" {
# 		43 |   ami           = "ami-0c55b159cbfafe1f0"
# 		44 |   instance_type = "t2.micro"
# 		45 |
# 		46 |   metadata_options {
# 		47 |     http_endpoint = "enabled"
# 		48 |     http_tokens   = var.http_tokens
# 		49 |   }
# 		50 | }
# ...

## Wiz CLI:

# <nothing about IMDSv1>

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.91.0"
    }
  }
}

provider "aws" {
  access_key                  = "xxxxxxxxxxxxxxxxxxxxxx"
  region                      = "us-east-1"
  secret_key                  = "xxxxxxxxxxxxxxxxxxxxxx"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

variable "http_tokens" {
  type = string
}

resource "aws_instance" "bad_instance_4" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = var.http_tokens
  }
}
