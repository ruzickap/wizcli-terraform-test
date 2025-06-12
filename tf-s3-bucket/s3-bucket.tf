# Description: This Terraform configuration creates public S3 bucket.

# Expected result: The deployment of the public S3 bucket should be detected and flagged as non-compliant because it allows public access.

# Example Output:

## Checkov

# ...
# Check: CKV_AWS_53: "Ensure S3 bucket has block public ACLS enabled"
# 	FAILED for resource: module.s3-bucket.aws_s3_bucket_public_access_block.this[0]
# 	File: /.external_modules/github.com/terraform-aws-modules/terraform-aws-s3-bucket/0d781fbb515b1f64c46bfba04153bef091d50fc5/main.tf:1067-1076
# 	Calling File: /main.tf:10-17
# 	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/s3-policies/bc-aws-s3-19

# 		1067 | resource "aws_s3_bucket_public_access_block" "this" {
# 		1068 |   count = local.create_bucket && var.attach_public_policy && !var.is_directory_bucket ? 1 : 0
# 		1069 |
# 		1070 |   bucket = aws_s3_bucket.this[0].id
# 		1071 |
# 		1072 |   block_public_acls       = var.block_public_acls
# 		1073 |   block_public_policy     = var.block_public_policy
# 		1074 |   ignore_public_acls      = var.ignore_public_acls
# 		1075 |   restrict_public_buckets = var.restrict_public_buckets
# 		1076 | }
# ...

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

module "s3-bucket" {
  # checkov:skip=CKV_AWS_300: encryption handled externally
  source                  = "git::https://github.com/terraform-aws-modules/terraform-aws-s3-bucket.git?ref=0d781fbb515b1f64c46bfba04153bef091d50fc5"
  block_public_acls       = false # <<<<<<<<<<<<<<<<<<<<<<<<<<<
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
