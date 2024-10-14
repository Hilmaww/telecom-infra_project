output "load_balancer_dns" {
  value = aws_lb.telecom_lb.dns_name
}

output "jenkins_url" {
  value = aws_instance.jenkins_server.public_ip
}
