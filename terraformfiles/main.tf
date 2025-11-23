variable "pem_file" {
  description = "Path to SSH private key"
  type        = string
}
resource "aws_instance" "test-server" {
  ami           = "ami-0fa3fe0fa7920f68e"
  instance_type = "t3.small"
  key_name      = "bookmyshow"  # your EC2 key pair (must already exist)
  vpc_security_group_ids = ["sg-05eb5a556e628a155"]
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.pem_file)
    host        = self.public_ip
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook ansiblebook.yml -i '${self.public_ip},' --private-key ${var.pem_file}"
}
 provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/zomatoapp/terraformfiles/ansiblebook.yml"
     }
  }


