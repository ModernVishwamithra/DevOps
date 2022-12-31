resource "null_resource" "name" {
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
  
}