provider "aws" {
  region = var.region
}

# -------------------------
# VPC, Subnet, Internet GW
# -------------------------
resource "aws_vpc" "app_vpc" {
  cidr_block = "10.0.0.0/16"
  tags       = { Name = "AppVPC" }
}

resource "aws_subnet" "app_subnet" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = { Name = "AppSubnet" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id
  tags   = { Name = "AppIGW" }
}

resource "aws_route_table" "app_rt" {
  vpc_id = aws_vpc.app_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "AppRouteTable" }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.app_subnet.id
  route_table_id = aws_route_table.app_rt.id
}

# -------------------------
# Security Groups
# -------------------------
resource "aws_security_group" "flask_sg" {
  name        = "flask-sg"
  vpc_id      = aws_vpc.app_vpc.id
  description = "Allow Flask app"

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr] # Optional public access
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "FlaskSG" }
}

resource "aws_security_group" "express_sg" {
  name        = "express-sg"
  vpc_id      = aws_vpc.app_vpc.id
  description = "Allow Express app"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "ExpressSG" }
}

# -------------------------
# Security Group Rules
# -------------------------
# Express can access Flask (5000)
resource "aws_security_group_rule" "express_to_flask" {
  type                     = "ingress"
  from_port                = 5000
  to_port                  = 5000
  protocol                 = "tcp"
  security_group_id         = aws_security_group.flask_sg.id
  source_security_group_id  = aws_security_group.express_sg.id
}

# Flask can access Express (3000) if needed
resource "aws_security_group_rule" "flask_to_express" {
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  security_group_id         = aws_security_group.express_sg.id
  source_security_group_id  = aws_security_group.flask_sg.id
}

# -------------------------
# EC2 Instances
# -------------------------
resource "aws_instance" "flask_instance" {
  ami                    = "ami-02d26659fd82cf299" # Ubuntu 22.04
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.app_subnet.id
  vpc_security_group_ids = [aws_security_group.flask_sg.id]
  key_name               = var.key_name

  user_data = file("./flask_user_data.sh")

  tags = { Name = "FlaskBackend" }
}

resource "aws_instance" "express_instance" {
  ami                    = "ami-02d26659fd82cf299" # Ubuntu 22.04
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.app_subnet.id
  vpc_security_group_ids = [aws_security_group.express_sg.id]
  key_name               = var.key_name

  user_data = file("./express_user_data.sh")

  tags = { Name = "ExpressFrontend" }
}
