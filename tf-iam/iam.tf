# Description: This is a Terraform code that creates an IAM role and attaches the AdministratorAccess policy to it

# Expected result: The IAM role should be created and the AdministratorAccess policy should be attached to it

## Checkov

# ...
# ...
# By Prisma Cloud | version: 3.2.440
# Update available 3.2.440 -> 3.2.445
# Run pip3 install -U checkov to update

# terraform scan results:

# Passed checks: 2, Failed checks: 2, Skipped checks: 0

# Check: CKV_AWS_274: "Disallow IAM roles, users, and groups from using the AWS AdministratorAccess policy"
# 	PASSED for resource: aws_iam_role.role-1
# 	File: /main.tf:2-15
# 	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/bc-aws-274
# Check: CKV_AWS_61: "Ensure AWS IAM policy does not allow assume role permission across all services"
# 	PASSED for resource: aws_iam_role.role-1
# 	File: /main.tf:2-15
# 	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/bc-aws-iam-45
# Check: CKV_AWS_60: "Ensure IAM role allows only specific services or principals to assume it"
# 	FAILED for resource: aws_iam_role.role-1
# 	File: /main.tf:2-15
# 	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/bc-aws-iam-44

# 		2  | resource "aws_iam_role" "role-1" {
# 		3  |   name = "admin-role-1"
# 		4  |
# 		5  |   assume_role_policy = jsonencode({
# 		6  |     Version = "2012-10-17"
# 		7  |     Statement = [{
# 		8  |       Effect = "Allow"
# 		9  |       Principal = {
# 		10 |         AWS = "*"
# 		11 |       }
# 		12 |       Action = "sts:AssumeRole"
# 		13 |     }]
# 		14 |   })
# 		15 | }

# Check: CKV_AWS_274: "Disallow IAM roles, users, and groups from using the AWS AdministratorAccess policy"
# 	FAILED for resource: aws_iam_role_policy_attachment.admin_attach
# 	File: /main.tf:17-20
# 	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/bc-aws-274

# 		17 | resource "aws_iam_role_policy_attachment" "admin_attach" {
# 		18 |   role       = aws_iam_role.role-1.name
# 		19 |   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
# 		20 | }

## Trivy:

# Noting...

## Wiz CLI:

# Noting...

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

resource "aws_iam_role" "role-1" {
  name = "admin-role-1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = "*"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "admin_attach" {
  role       = aws_iam_role.role-1.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
