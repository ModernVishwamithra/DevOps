resource "aws_vpc" "vpc_test" {
  cidr_block = "10.1.0.0/16"
  enable_dns_support = true
enable_dns_hostnames = true
tags={
    Name = "Test VPC"
}
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.vpc_test.id

  tags = {
    Name = "My IGW"
  }
}


resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.vpc_test.id
    route  {
        cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.my_igw.id
    }
   tags = {
    Name = "Public RT"
  }
}
resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.vpc_test.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }


  tags = {
    Name = "Default rt"
  }
}

resource "aws_route_table_association" "rt-assoc-1" {
    route_table_id = aws_default_route_table.default.id
    subnet_id = aws_subnet.public-subnet-1.id 
}
resource "aws_route_table_association" "rt-assoc-2" {
    route_table_id = aws_default_route_table.default.id
    subnet_id = aws_subnet.public-subnet-2.id 
}
resource "aws_route_table_association" "rt-assoc-3" {
    route_table_id = aws_default_route_table.default.id
    subnet_id = aws_subnet.public-subnet-3.id 
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_all"
  description = "Allow All traffic"
  vpc_id      = aws_vpc.vpc_test.id

  ingress {
    description      = "Allow ingress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
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
    Name = "allow_all"
  }
}

resource "aws_key_pair" "hp_ssh" {
  key_name   = "hp_ssh"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQoXqWrZGnOuJEceBk8q74Aw/gD0ko37j41mKE35WRTabpTVJhIB8ksdYLfJQdRgKatoEhFW50fJVqiYW8LE3tySc0ibrNV5mGWj+Crw1UmHRGeIwY6tdkbg1QIzA7JD/Kz+LiUcRyTbEuC6OXaxA8I751AQ5xuKh1nCnN6rjL3pmGfViUTJBETzgttxHYQOoWeYNjZ306kP8cjqQjvRC5ejQoTpf3jSmOFGYw+CwWc6sA2taBjWVJF72f5wgC7KbIC8cVfzUNtSUmKO5mBGF9ywc/ab5cAWLViVhUTrCQJmSCFoRh/vMo5+y1pK8V6nBJF4k/Kw+tEIBkPBxizAg09zyPo5y2Sms78WLELE5m0Ob6VZdBqy+9UeHVgDDRF4RRMxp1xhOEC+1mrGyqBU4r70+VBo0n+zPkmTF8FoUDCt7wF8XKtTFL7+H+g0XxYjuFlI4gwfIlg3sD8Q51lYtCravqOSBNQh/FvklrNVh2wq8HUV39o3hSZ5WEjP9+Omc= pavan@DESKTOP-TTAFTCU"
}

# Create an IAM policy
resource "aws_iam_policy" "asg_elb_iam_policy" {
  name = var.iam_policy_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          	"elasticloadbalancing:*",
			"autoscaling-plans:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create an IAM role
resource "aws_iam_role" "asg_elb_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the IAM policy to the IAM role
resource "aws_iam_policy_attachment" "asg_elb_role_policy_attachment" {
  name = "Policy Attachement"
  policy_arn = aws_iam_policy.asg_elb_iam_policy.arn
  roles       = [aws_iam_role.asg_elb_role.name]
}

# Create an IAM instance profile
resource "aws_iam_instance_profile" "asg_elb_instance_profile" {
  name = var.instance_profile_name
  role = aws_iam_role.asg_elb_role.name
}

resource "aws_instance" "nginx-server" {
    count = 3
    ami = "ami-0f5ee92e2d63afc18" #ap-south-1
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public-subnet-1.id
    associate_public_ip_address = true
    key_name = aws_key_pair.hp_ssh.key_name
    vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
    user_data = <<-EOF
    #! /bin/bash
sudo apt-get update
sudo apt-get install -y nginx
echo "<h1>Nginx server 1</h1>" | sudo tee /var/www/html/index.nginx-debian.html
  EOF
    iam_instance_profile = aws_iam_instance_profile.asg_elb_instance_profile.name
  

    tags = {
      Name = "Nginx webserver"
    }
}

