# Configure the AWS Provider
provider "aws" {
  version = "~> 2.70"
  # Optional
  region  = "eu-west-1"
}

# 1. Create a VPC
resource "aws_vpc" "pr03-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "pr03-vpc"
  }
}

# 2. Create an internet gateway
resource "aws_internet_gateway" "pr03-gw" {
  vpc_id = aws_vpc.pr03-vpc.id

  tags = {
    Name = "pr03-gw"
  }
}

# 3. Create a custom route table
resource "aws_route_table" "pr03-r" {
  vpc_id = aws_vpc.pr03-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pr03-gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.pr03-gw.id
  }

  tags = {
    Name = "pr03-r"
  }
}

# 4. Create a subnet
resource "aws_subnet" "pr03-subnet-1" {
  vpc_id            = aws_vpc.pr03-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "pr03-subnet-1"
  }
}

# 5. Associate the subnet with the route table
resource "aws_route_table_association" "pr03-a" {
  subnet_id      = aws_subnet.pr03-subnet-1.id
  route_table_id = aws_route_table.pr03-r.id
}

# 6. Create a security group to allow ports 22, 80, 443
resource "aws_security_group" "pr03-allow_web_traffic" {
  name        = "allow_web_traffic"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.pr03-vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # We want internet to access it
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # We want internet to access it
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    # We want internet to access it
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pr03-allow_web_traffic"
  }
}

# 7. Create a network interface with an ip in the subnet
resource "aws_network_interface" "pr03-nic" {
  subnet_id       = aws_subnet.pr03-subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.pr03-allow_web_traffic.id]
}

# 8. Assign an elastic IP to the network interface
resource "aws_eip" "pr03-eip" {
  vpc                       = true
  network_interface         = aws_network_interface.pr03-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.pr03-gw]
}

# 9. Create an Ubuntu server and install/enable Apache 2
resource "aws_instance" "pr03-web_server" {
  ami               = "ami-099926fbf83aa61ed"
  instance_type     = "t2.micro"
  availability_zone = "eu-west-1a"
  key_name          = "terraform-tutorial"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.pr03-nic.id
  }

  # Install Apache 2
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo your very first web server > /var/www/html/index.html'
              EOF

  tags = {
    Name = "pr03-web_server"
  }
}

# Print the elastic IP when execution finishes
output "server_public_ip" {
  value = aws_eip.pr03-eip.public_ip
}

# Print the private IP of the server when execution finishes
output "server_private_ip" {
  value = aws_instance.pr03-web_server.private_ip
}

# Print the ID of the server when execution finishes
output "server_id" {
  value = aws_instance.pr03-web_server.id
}