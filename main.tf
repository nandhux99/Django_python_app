terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "public-sg" {
  name        = "public-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = vpc-01684237ae784ff52
  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
  }
   ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "public-sg"
  }
}

resource "aws_instance" "Ec2"{
    ami = "ami-0c7217cdde317cfec"
    instance_type = "t2.micro"
    key_name  =  "demokey"
    vpc_security_group_ids= [aws_security_group.public-sg.id]
    associate_public_ip_address = true
}
