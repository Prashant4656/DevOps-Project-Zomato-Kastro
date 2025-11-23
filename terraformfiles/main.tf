variable "pem_file" {
  description = "PEM file path from Jenkins"
  type        = string
}

resource "aws_instance" "test-server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "bookmyshow"  # your EC2 key pair (must already exist)

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.pem_file)
    host        = self.public_ip
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook ansiblebook.yml -i '${self.public_ip},' --private-key ${var.pem_file}"
  }
}

