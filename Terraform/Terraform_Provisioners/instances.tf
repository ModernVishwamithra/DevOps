resource "aws_ec2_instance" "public-servers" {
    count = var.environment == "Dev" ? 1 : 2
    ami = lookup(var.amis,var.region)
    instance_type = var.instance_type
    subnet_id = element(aws_subnet.public-subnet.*.id, count.index)
    key_pair = var.key_pair 
    associate_public_ip_address = true
    vpc_security_group_ids = ["${aws_security_group.sg.id}"]
    user_data = <<-EOF
    #! /bin/bash
sudo yum update
sudo yum install -y nginx
echo "<h1>Public server ${count.index}</h1>" | sudo tee /var/www/html/index.html
  EOF
  tags {
    Name = "Public-server-${count.index + 1}"
  }
}

resource "aws_ec2_instance" "private-servers" {
    count = var.environment == "Dev" ? 1 : 2
    ami = lookup(var.amis,var.region)
    instance_type = var.instance_type
    subnet_id = element(aws_subnet.private-subnet.*.id, count.index)
    key_pair = var.key_pair 
    associate_public_ip_address = false
    vpc_security_group_ids = ["${aws_security_group.sg.id}"]
    user_data = <<-EOF
    #! /bin/bash
sudo yum update
sudo yum install -y nginx
echo "<h1>Private server ${count.index}</h1>" | sudo tee /var/www/html/index.html
  EOF
  tags {
    Name = "Private-server-${count.index + 1}"
  }
depends_on = [
  aws_nat_gateway.nat-gw
]
}