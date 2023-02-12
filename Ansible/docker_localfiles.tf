resource "local_file" "template_docker" {
  content = templatefile("docker_template.tpl",
    {
      client01 = aws_instance.web-1.public_ip
      client02 = aws_instance.web-2.public_ip
      client03 = aws_instance.web-3.public_ip
      client04 = aws_instance.web-4.public_ip
      client05 = aws_instance.web-5.public_ip
      client06 = aws_instance.web-6.public_ip

      client01_private = aws_instance.web-1.private_ip
      client02_private = aws_instance.web-2.private_ip
      client03_private = aws_instance.web-3.private_ip
      client04_private = aws_instance.web-4.private_ip
      client05_private = aws_instance.web-5.private_ip
      client06_private = aws_instance.web-6.private_ip
    }
  )
  filename = "dockerinvfile"
}