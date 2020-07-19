# Configure the AWS Provider
provider "aws" {
  version = "~> 2.70" # Optional
  region  = "eu-west-1"
}

resource "aws_instance" "project_01_server" {
  ami           = "ami-099926fbf83aa61ed"
  instance_type = "t2.micro"

  tags = {
    Name = "ubuntu"
  }
}
