resource "aws_subnet" "public_subnet" {
  count = 2
  vpc_id     = aws_vpc.telecom_vpc.id
  cidr_block = cidrsubnet(aws_vpc.telecom_vpc.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
}

resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  vpc_id      = aws_vpc.telecom_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}
