resource "aws_instance" "app_server-1" {
  ami           = var.imagename
  instance_type = var.instanceType
  key_name = var.keypair
  subnet_id = data.terraform_remote_state.state_import.outputs.subnet-1_id
  vpc_security_group_ids = [data.terraform_remote_state.state_import.outputs.sg_id]
  associate_public_ip_address = true

  tags = {
    Name = "App_Server-1"
  }
  user_data = <<-EOF
		#! /bin/bash
    sudo apt-get update
		sudo apt-get install -y nginx jq unzip
		echo "<h1>Deployed via Terraform state import on App_Server-1</h1>" | sudo tee /var/www/html/index.html
	EOF
}

resource "aws_instance" "app_server-2" {
  ami           = var.imagename
  instance_type = var.instanceType
  key_name = var.keypair
  subnet_id = data.terraform_remote_state.state_import.outputs.subnet-1_id
  vpc_security_group_ids = [data.terraform_remote_state.state_import.outputs.sg_id]
  associate_public_ip_address = true

  tags = {
    Name = "App_Server-2"
  }
  user_data = <<-EOF
		#! /bin/bash
    sudo apt-get update
		sudo apt-get install -y nginx jq unzip
		echo "<h1>Deployed via Terraform state import on App_Server-2</h1>" | sudo tee /var/www/html/index.html
	EOF
}

resource "aws_instance" "app_server-3" {
  ami           = var.imagename
  instance_type = var.instanceType
  key_name = var.keypair
  subnet_id = data.terraform_remote_state.state_import.outputs.subnet-1_id
  vpc_security_group_ids = [data.terraform_remote_state.state_import.outputs.sg_id]
  associate_public_ip_address = true

  tags = {
    Name = "App_Server-3"
  }
  user_data = <<-EOF
		#! /bin/bash
    sudo apt-get update
		sudo apt-get install -y nginx jq unzip
		echo "<h1>Deployed via Terraform state import on App_Server-3</h1>" | sudo tee /var/www/html/index.html
	EOF
}