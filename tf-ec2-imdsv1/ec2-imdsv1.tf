# Description: This Terraform configuration creates two EC2 instances that use IMDSv1.

# Expected result: Both instances should be flagged as non-compliant because they are configured to use IMDSv1.

# Example Output:

## Checkov

# Check: CKV_AWS_79: "Ensure Instance Metadata Service Version 1 is not enabled"
# 	FAILED for resource: aws_instance.bad_instance
# Error: 	File: /ec2-imdsv1.tf:25-33
# 	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-general-policies/bc-aws-general-31

# 		25 | resource "aws_instance" "bad_instance" {
# 		26 |   ami           = "ami-0c55b159cbfafe1f0"
# 		27 |   instance_type = "t2.micro"
# 		28 |
# 		29 |   metadata_options {
# 		30 |     http_endpoint = "enabled"
# 		31 |     http_tokens   = "optional"
# 		32 |   }
# 		33 | }

# Check: CKV_AWS_79: "Ensure Instance Metadata Service Version 1 is not enabled"
# 	FAILED for resource: aws_instance.bad_instance_2
# Error: 	File: /ec2-imdsv1.tf:35-43
# 	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-general-policies/bc-aws-general-31

# 		35 | resource "aws_instance" "bad_instance_2" {
# 		36 |   ami           = "ami-0c55b159cbfafe1f0"
# 		37 |   instance_type = "t2.micro"
# 		38 |
# 		39 |   metadata_options {
# 		40 |     http_endpoint = "enabled"
# 		41 |     http_tokens   = local.http_tokens
# 		42 |   }
# 		43 | }


## Trivy:

# HIGH: Instance does not require IMDS access to require a token.
# ════════════════════════════════════════
# IMDS v2 (Instance Metadata Service) introduced session authentication tokens which improve security when talking to IMDS.

# By default <code>aws_instance</code> resource sets IMDS session auth tokens to be optional.

# To fully protect IMDS you need to enable session tokens by using <code>metadata_options</code> block and its <code>http_tokens</code> variable set to <code>required</code>.


# See https://avd.aquasec.com/misconfig/avd-aws-0028
# ────────────────────────────────────────
#  ec2-imdsv1.tf:31
#    via ec2-imdsv1.tf:29-32 (metadata_options)
#     via ec2-imdsv1.tf:25-33 (aws_instance.bad_instance)
# ────────────────────────────────────────
#   25   resource "aws_instance" "bad_instance" {
#   26     ami           = "ami-0c55b159cbfafe1f0"
#   27     instance_type = "t2.micro"
#   28
#   29     metadata_options {
#   30       http_endpoint = "enabled"
#   31 [     http_tokens   = "optional"
#   32     }
#   33   }
# ──────────────────────────────────���─────
# ...
# ...
# ...
# HIGH: Instance does not require IMDS access to require a token.
# ════════════════════════════════════════
# IMDS v2 (Instance Metadata Service) introduced session authentication tokens which improve security when talking to IMDS.

# By default <code>aws_instance</code> resource sets IMDS session auth tokens to be optional.

# To fully protect IMDS you need to enable session tokens by using <code>metadata_options</code> block and its <code>http_tokens</code> variable set to <code>required</code>.


# See https://avd.aquasec.com/misconfig/avd-aws-0028
# ────────────────────────────────────────
#  ec2-imdsv1.tf:41
#    via ec2-imdsv1.tf:39-42 (metadata_options)
#     via ec2-imdsv1.tf:35-43 (aws_instance.bad_instance_2)
# ────────────────────────────────────────
#   35   resource "aws_instance" "bad_instance_2" {
#   36     ami           = "ami-0c55b159cbfafe1f0"
#   37     instance_type = "t2.micro"
#   38
#   39     metadata_options {
#   40       http_endpoint = "enabled"
#   41 [     http_tokens   = local.http_tokens
#   42     }
#   43   }
# ────────────────────────────────────────



terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.91.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  http_tokens = "optional"
}

resource "aws_instance" "bad_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }
}

resource "aws_instance" "bad_instance_2" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = local.http_tokens
  }
}
