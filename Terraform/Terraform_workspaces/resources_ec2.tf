resource "aws_instance" "web" {
  ami           = var.imagename
  instance_type = "t2.micro"
  key_name = "msi-keypair"
  subnet_id = aws_subnet.public-subnet-1.id
  vpc_security_group_ids = ["${aws_security_group.allow_traffic.id}"]
  associate_public_ip_address = true

  tags = {
    Name = "${var.env}-instance"
  }
  user_data = <<-EOF
  #! /bin/bash
sudo apt-get update
sudo apt-get install nginx
echo "<h1>${var.env}-instance</h1>" | sudo tee /var/www/html/index.html
  EOF
}