#This Terraform Code Deploys Basic VPC Infra.
provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = "<= 2.0.14" #Forcing which version of Terraform needs to be used
  required_providers {
    aws = {
      version = "<= 5.0.0" #Forcing which version of plugin needs to be used.
      source  = "hashicorp/aws"
    }
  }
}

# terraform {
#   required_version = "1.3.6" # this is the terraform version to be used , we are forcing to use this
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.0" # this is the aws version to be used 
#     }
#   }
# }

resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.vpc_name}"
    Owner       = "Pavan Kumar Pacharla"
    environment = "${var.environment}"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "${var.IGW_name}"
  }
}

resource "aws_subnet" "subnet1-public" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.public_subnet1_cidr
  availability_zone = "us-east-2a"

  tags = {
    Name = "${var.public_subnet1_name}"
  }
}

resource "aws_subnet" "subnet2-public" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.public_subnet2_cidr
  availability_zone = "us-east-2b"

  tags = {
    Name = "${var.public_subnet2_name}"
  }
}

resource "aws_subnet" "subnet3-public" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.public_subnet3_cidr
  availability_zone = "us-east-2c"

  tags = {
    Name = "${var.public_subnet3_name}"
  }

}


resource "aws_route_table" "terraform-public" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name = "${var.Main_Routing_Table}"
  }
}

resource "aws_route_table_association" "terraform-public" {
  subnet_id      = aws_subnet.subnet1-public.id
  route_table_id = aws_route_table.terraform-public.id
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "my_ami" {
  most_recent = true
  name_regex  = "^Packer"
  owners      = ["582469332580"]
}


resource "aws_instance" "web-1" {
  #ami = var.imagename
  ami = "ami-02ae910d3317bfe96"
  # ami                         = data.aws_ami.my_ami.id
  availability_zone           = "us-east-2a"
  instance_type               = "t2.micro"
  key_name                    = "msi-keypair"
  subnet_id                   = aws_subnet.subnet1-public.id
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
  associate_public_ip_address = true
  tags = {
    Name       = "Server-1"
    Env        = "Prod"
    Owner      = "Pavan"
    CostCenter = "ABCD"
  }
}

resource "aws_instance" "web-2" {
  count = 2
  #ami = var.imagename
  #ami = "ami-00c3c63f29f7ed1e5"
  ami                         = data.aws_ami.my_ami.id #without deleting the 1st server we are creating the instance with latest AMI
  availability_zone           = "us-east-2a"
  instance_type               = "t2.micro"
  key_name                    = "msi-keypair"
  subnet_id                   = aws_subnet.subnet1-public.id
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
  associate_public_ip_address = true
  tags = {
    Name       = "Server-0${count.index+1}"
    Env        = "Prod"
    Owner      = "Pavan"
    CostCenter = "ABCD"
  }
}

