terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MyVPC"
  }
}

# Create Subnet
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "MySubnet"
  }
}

# Create Security Group
resource "aws_security_group" "my_sg" {
  vpc_id = aws_vpc.my_vpc.id

  # Allow SSH (Port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP (Port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow All Outbound Traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MySecurityGroup"
  }
}

# Create EC2 Instance
resource "aws_instance" "my_ec2" {
  ami             = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 (Update for your region)
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.my_sg.name]
  key_name        = var.key_pair

  tags = {
    Name = "MyEC2Instance"
  }
}

# Create S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name = "MyS3Bucket"
  }
}
