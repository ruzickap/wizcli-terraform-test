# Test description: Ensure that EC2 instances do not use IMDSv1
# Both instances should be detected as non-compliant due to the use of IMDSv1

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
