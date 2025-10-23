terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}
provider "aws" {
  region = var.region
}

resource "aws_instance" "flask_express_server" {
  ami           = var.ubuntu_ami   # Ubuntu 22.04 LTS AMI
  instance_type = "t2.micro"
  key_name      = var.key_name

  user_data = file("./user_data.sh")

  tags = {
    Name = "Flask-Express-Ubuntu"
  }

  vpc_security_group_ids = [aws_security_group.allow_web_traffic.id]
}

resource "aws_security_group" "allow_web_traffic" {
  name_prefix = "flask-express-sg-"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }
  
  ingress {
    description = "allow nginx port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Flask app"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Express app"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

