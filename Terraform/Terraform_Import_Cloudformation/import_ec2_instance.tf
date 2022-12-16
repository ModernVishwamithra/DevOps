resource "aws_instance" "webserver-1" {
  ami                         = "ami-0283a57753b18025b"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public-subnet-1.id
  key_name                    = "msi-keypair"
  vpc_security_group_ids      = ["${aws_security_group.mytestvpc-sg.id}"]


  tags = {
    "App"   = "Production"
    "Env"   = "Prod"
    "Name"  = "WebServer-1"
    "Team" = "JavaAppTeam"
  }
  tags_all = {
    "App"   = "Production"
    "Env"   = "Prod"
    "Name"  = "WebServer-1"
    "Team" = "JavaAppTeam"
  }
}

resource "aws_instance" "webserver-2" {
  ami                         = "ami-0283a57753b18025b"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public-subnet-2.id
  key_name                    = "msi-keypair"
  vpc_security_group_ids      = ["${aws_security_group.mytestvpc-sg.id}"]


  tags = {
    "App"   = "Production"
    "Env"   = "Prod"
    "Name"  = "WebServer-2"
    "Team" = "JavaAppTeam"
  }
  tags_all = {
    "App"   = "Production"
    "Env"   = "Prod"
    "Name"  = "WebServer-2"
    "Team" = "JavaAppTeam"
  }
}

resource "aws_instance" "webserver-3" {
  ami                         = "ami-0283a57753b18025b"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public-subnet-3.id
  key_name                    = "msi-keypair"
  vpc_security_group_ids      = ["${aws_security_group.mytestvpc-sg.id}"]


  tags = {
    "App"   = "Production"
    "Env"   = "Prod"
    "Name"  = "WebServer-3"
    "Team" = "JavaAppTeam"
  }
  tags_all = {
    "App"   = "Production"
    "Env"   = "Prod"
    "Name"  = "WebServer-3"
    "Team" = "JavaAppTeam"
  }
}