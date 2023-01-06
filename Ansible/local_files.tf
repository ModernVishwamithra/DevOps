resource "local_file" "template" {
  content = templatefile("template.tpl",
    {
      client01 = aws_instance.web-1.public_ip
      client02 = aws_instance.web-2.public_ip
      client03 = aws_instance.web-3.public_ip
    }
  )
  filename = "invfile"
}