resource "aws_instance" "test-server" {
  ami = "ami-0fa3fe0fa7920f68e"
  instance_type = "t2.medium"
  key_name = "jyoti"
  vpc_security_group_ids = ["sg-008fe5ebc9e6c8628"]
  connection {
     type = "ssh"
     user = "ec2-user"
     private_key = file("./jyoti.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/zomatoapp/terraform-files/ansiblebook.yml"
     }
  }
