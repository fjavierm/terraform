 # Configure the AWS Provider
provider "aws" {
  version = "~> 2.70" # Optional
  region  = "eu-west-1"
}

# Create a VPC
resource "aws_vpc" "pr02-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "pr02-vpc"
  }
}

# Create a subnet
resource "aws_subnet" "pr2-subnet-1" {
  vpc_id     = aws_vpc.pr02-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "pr2-subnet-1"
  }
}
