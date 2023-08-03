provider "aws" {
   region = var.region
}


resource "aws_instance" "demo" {
    ami = var.os_name
    key_name = var.key
    instance_type = var.instance_type
    subnet_id = aws_subnet.demo_subnet_1.id
    vpc_security_group_ids = [aws_security_group.demo-vpc-sg.id] 
    associate_public_ip_address = true

      tags = {
    Name = "kubernetes-Master"
  }

}

#create VPC 
resource "aws_vpc" "demo-vpc" {
    cidr_block = var.vpc_cidr

  
}

#create subnet
#A
resource "aws_subnet" "demo_subnet_1" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = var.subnet1_cidr
  availability_zone = var.subnet_az
  map_public_ip_on_launch = "true"
  tags = {
    Name = "demo_subnet_1"
  }
}

#B
resource "aws_subnet" "demo_subnet_2" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = var.subnet2_cidr
  availability_zone = var.subnet_2_az
  map_public_ip_on_launch = "true"
  
  tags = {
    Name = "demo_subnet_2"
  }
}

#create internet Gateway
resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "demo-igw"
  }
}

#route Table
resource "aws_route_table" "demo_rt" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }

  tags = {
    Name = "demo_rt"
  }
}

#subnet association
#A
resource "aws_route_table_association" "demo_rt_association_1" {
  subnet_id      = aws_subnet.demo_subnet_1.id
  route_table_id = aws_route_table.demo_rt.id
}
#B
resource "aws_route_table_association" "demo_rt_association_2" {
  subnet_id      = aws_subnet.demo_subnet_2.id
  route_table_id = aws_route_table.demo_rt.id
}

#security group
resource "aws_security_group" "demo-vpc-sg" {
  name        = "demo-vpc-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.demo-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "demo-vpc-sg"
  }
}

module "sgs" {
  source = "./sg_eks"
  vpc_id = aws_vpc.demo-vpc.id
}

module "eks" {
  source = "./eks"
  sg_ids= module.sgs.security_group_public
  vpc_id = aws_vpc.demo-vpc.id
  subnet_ids = [aws_subnet.demo_subnet_1.id,aws_subnet.demo_subnet_2.id]
}
