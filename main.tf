terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_vpc" "telecom_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "telecom-vpc"
  }
}
