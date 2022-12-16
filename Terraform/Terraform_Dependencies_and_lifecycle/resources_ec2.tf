resource "aws_instance" "app_server-1" {
  ami           = "ami-0beaa649c482330f7"
  instance_type = "t2.micro"
  key_name = "msi-keypair"
  subnet_id = aws_subnet.public-subnet-1.id
  vpc_security_group_ids = [aws_security_group.allow_traffic_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "App_Server-2"
    Superstar = "Mahesh"
  }
  lifecycle {
    create_before_destroy = true
    #prevent_destroy = true
  }
#   user_data = <<-EOF
# 		#! /bin/bash
#     sudo apt-get update
# 		sudo apt-get install -y nginx jq unzip
# 		echo "<h1>Deployed via Terraform state import on App_Server-1</h1>" | sudo tee /var/www/html/index.html
# 	EOF
}