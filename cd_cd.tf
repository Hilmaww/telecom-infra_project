resource "aws_instance" "jenkins_server" {
  ami           = var.ami_id
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.public_subnet[0].id
  security_groups = [aws_security_group.allow_http_ssh.id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y docker
    systemctl start docker
    systemctl enable docker
    docker run -d -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts
  EOF
}
