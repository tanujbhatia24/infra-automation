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
  availability_zone = var.availability_zone
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
  tags = {
    Name = "ecommerce-sg"
  }
}

resource "aws_instance" "ecommerce" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install docker.io -y
              sudo systemctl start docker
              sudo docker pull tanujbhatia24/user-service
              sudo docker pull tanujbhatia24/product-service
              sudo docker pull tanujbhatia24/order-service
              sudo docker pull tanujbhatia24/cart-service
              sudo docker pull tanujbhatia24/frontend-service

              sudo docker network create ecommerce-net
              sudo docker run -d --name mongodb --network ecommerce-net -p 27017:27017 mongo

              sudo docker run -d --name user-service --network ecommerce-net -p 3001:3001 -e MONGO_URL=mongodb://mongodb:27017/userdb tanujbhatia24/user-service
              sudo docker run -d --name product-service --network ecommerce-net -p 3002:3002 -e MONGO_URL=mongodb://mongodb:27017/userdb tanujbhatia24/product-service
              sudo docker run -d --name order-service --network ecommerce-net -p 3004:3004 -e MONGO_URL=mongodb://mongodb:27017/userdb tanujbhatia24/order-service
              sudo docker run -d --name cart-service --network ecommerce-net -p 3003:3003 -e MONGO_URL=mongodb://mongodb:27017/userdb tanujbhatia24/cart-service
              sudo docker run -d --name frontend-service --network ecommerce-net -p 3000:3000 -e MONGO_URL=mongodb://mongodb:27017/userdb tanujbhatia24/frontend-service
              EOF

  tags = {
    Name = "tanuj-EcommerceApp"
  }
}
