resource "null_resource" "name" {
  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("msi-keypair.pem")
      host        = aws_instance.public-servers.public_ip
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

  provisioner "local-exec" {
    command = <<EOH
    echo "Public server ip is ${aws_instance.public-servers.public_ip}" >> public_server_ip && echo "Public server ip is ${aws_instance.private-servers.private_ip}" >> private_server_ip
    EOH
  }
}