# WizCLI Terraform Test code

Terraform code examples contain various issues that can be identified by tools
like Checkov or Trivy, but not by Wiz CLI.

Tests:

* [ec2-imdsv1.tf](./ec2-imdsv1.tf) - Both instances should be flagged as
non-compliant because they are configured to use IMDSv1.
