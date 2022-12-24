resource "aws_instance" "public-servers" {
  //count                       = length(var.cidr_subnets_block_public) //dynamic way of giving count value
  count = var.env == "Dev" ? 2 : 1
  # ami                         = "ami-0beaa649c482330f7"
  ami                         = lookup(var.amis, var.region)
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = element(aws_subnet.ohio-public-subnets.*.id, count.index)
  key_name                    = var.key_pair
  user_data                   = <<-EOF
  #! /bin/bash
sudo yum update
sudo yum install -y nginx
echo "<h1>Public server ${count.index}</h1>" | sudo tee /var/www/html/index.html
  EOF
  vpc_security_group_ids      = ["${aws_security_group.allow_traffic_sg.id}"]
  tags = {
    Name = "Public server ${count.index}"
  }

}

resource "aws_instance" "private-servers" {
  count = 1
  //count                       = length(var.cidr_subnets_block_private) //dynamic way of giving count value
  ami                         = "ami-0beaa649c482330f7"
  instance_type               = var.instance_type
  associate_public_ip_address = false
  subnet_id                   = element(aws_subnet.ohio-private-subnets.*.id, count.index)
  key_name                    = var.key_pair
  user_data                   = <<-EOF
  #! /bin/bash
sudo yum update 
sudo yum install -y nginx
echo "<h1>Private server ${count.index}</h1>" | sudo tee /var/www/html/index.html
  EOF
  # for ubuntu use 'apt-get', for amazon linux use 'yum'
  vpc_security_group_ids = ["${aws_security_group.allow_traffic_sg.id}"]
  tags = {
    Name = "Private server ${count.index}"
  }
  depends_on = [aws_nat_gateway.ohio-nat-gw]
}