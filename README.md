# WizCLI Terraform Test code

Terraform code examples contain various issues that can be identified by
tools like Checkov or Trivy, but not by Wiz CLI.

Tests:

* [ec2-imdsv1.tf](./tf-ec2-imdsv1/ec2-imdsv1.tf) - both instances should be
  flagged as non-compliant because they are configured to use IMDSv1

* [s3-bucket.ft](./tf-s3-bucket/s3-bucket.tf) - public s3 bucket created using
  TF module

* [iam.tf](./tf-iam/iam.tf) - creates an IAM role and attaches the
  AdministratorAccess policy to it
