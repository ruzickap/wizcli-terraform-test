# WizCLI fails with the following medium failed rules in the 
# mck-all-wizcli-misconfigurations-block-all policy:

# Expected: Security Group inbound rule should allow a specific port
# Found: aws_security_group_rule[ingress_with_source_sg_id] 'to_port' and 'from_port' have different values

# Expected: Security Group outbound rule should allow a specific port
# Found: aws_security_group_rule[egress_with_source_sg_id] 'to_port' and 'from_port' have different values

# This is a false positive, as from_port and to_port could have different values. 
# Reasoning:
# Some enterprise applications legitimately require security group port ranges for correct operation. Examples include:
# - Elasticsearch clusters: transport ports 9300–9400 are used for node-to-node communication.
# - Oracle RAC: additional listeners may use ranges such as 1522–1529.
# - PeopleSoft: Jolt load balancing commonly uses 9000–9010.

# In these cases, defining a port range is an intentional configuration driven by application requirements rather than an inadvertent misconfiguration.

## Testing - update VPC ID variable
variable "vpc_id" {
    default = "vpc-123456"
}

terraform {
  required_version = ">= 1.4.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.9.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  skip_credentials_validation = true
}

resource "aws_security_group" "elasticsearch_sg" {
  name_prefix = "elasticsearch-sg-"
  description = "Security group for Elasticsearch nodes"
  
  vpc_id = var.vpc_id

  # Inbound rule for Elasticsearch communication
  ingress {
    description = "Elasticsearch communication"
    from_port   = 9200
    to_port     = 9400
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Outbound rule - allow all outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "elasticsearch-security-group"
    Service     = "elasticsearch"
  }
}