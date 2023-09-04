resource "aws_subnet" "public-subnet-1" {
    vpc_id = aws_vpc.vpc_test.id
    cidr_block = "10.1.10.0/24"
    tags = {
      Name = "Public-subnet-1"
    }
    availability_zone = "ap-south-1a"
}

resource "aws_subnet" "public-subnet-2" {
    vpc_id = aws_vpc.vpc_test.id
    cidr_block = "10.1.20.0/24"
    tags = {
      Name = "Public-subnet-2"
    }
    availability_zone = "ap-south-1b"
}

resource "aws_subnet" "public-subnet-3" {
    vpc_id = aws_vpc.vpc_test.id
    cidr_block = "10.1.30.0/24"
    tags = {
      Name = "Public-subnet-3"
    }
    availability_zone = "ap-south-1c"
}

