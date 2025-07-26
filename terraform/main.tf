provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "ec2_sg" {
  name        = "ecommerce-sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow backend ports"
    from_port   = 3001
    to_port     = 3004
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

resource "aws_instance" "ecommerce" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id
  security_groups = [aws_security_group.ec2_sg.name]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install docker.io -y
              systemctl start docker
              docker pull tanujbhatia24/user-service
              docker pull tanujbhatia24/product-service
              docker pull tanujbhatia24/order-service
              docker pull tanujbhatia24/cart-service
              docker pull tanujbhatia24/frontend-service

              docker run -d -p 3001:3001 tanujbhatia24/user-service
              docker run -d -p 3002:3002 tanujbhatia24/product-service
              docker run -d -p 3003:3003 tanujbhatia24/order-service
              docker run -d -p 3004:3004 tanujbhatia24/cart-service
              docker run -d -p 3000:3000 tanujbhatia24/frontend-service

              docker run -d -p 27017:27017 --name mongodb mongo
              EOF

  tags = {
    Name = "tanuj-EcommerceApp"
  }
}
