resource "local_file" "welcome" {
  content  = "Welcome to Devops learning"
  filename = "${path.module}/welcome.log"
}

resource "local_file" "template" {
  content  = templatefile("template.tpl",
  {
    public-ip = aws_instance.public-servers.public_ip
    private-ip = aws_instance.private-servers.private_ip
  }
  )
  filename = "invfile"
}