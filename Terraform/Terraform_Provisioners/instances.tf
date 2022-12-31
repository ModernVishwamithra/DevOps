resource "aws_instance" "public-servers" {
  #count                       = var.environment == "Dev" ? 1 : 2
  ami           = lookup(var.amis, var.region)
  instance_type = var.instance_type
  #subnet_id                   = element(aws_subnet.public-subnet.0.id, count.index)
  subnet_id                   = aws_subnet.public-subnet.0.id
  key_name                    = var.key_pair
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.sg.id}"]
  user_data                   = <<-EOF
    #! /bin/bash
sudo apt-get update
sudo apt-get install -y nginx
echo "<h1>Public server 1</h1>" | sudo tee /var/www/html/index.html
  EOF
   provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("msi-keypair.pem")
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 777 /tmp/script.sh",
      "sudo /tmp/script.sh",
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("msi-keypair.pem")
      host        = aws_instance.public-servers.public_ip
    }
  }
  tags = {
    # Name = "Public-server-${count.index + 1}"
    Name = "Public-server-1"
  }
}

resource "aws_instance" "private-servers" {
  #   count                       = var.environment == "Dev" ? 1 : 2
  ami           = lookup(var.amis, var.region)
  instance_type = var.instance_type
  #   subnet_id                   = element(aws_subnet.private-subnet.0.id, count.index)
  subnet_id                   = aws_subnet.private-subnet.0.id
  key_name                    = var.key_pair
  associate_public_ip_address = false
  vpc_security_group_ids      = ["${aws_security_group.sg.id}"]
  user_data                   = <<-EOF
    #! /bin/bash
sudo apt-get update
sudo apt-get install -y nginx
echo "<h1>Private server 1</h1>" | sudo tee /var/www/html/index.html
  EOF

  tags = {
    # Name = "Private-server-${count.index + 1}"
    Name = "Private-server-1"
  }
  depends_on = [
    aws_nat_gateway.nat-gw
  ]
}
