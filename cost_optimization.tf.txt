resource "aws_spot_instance_request" "telecom_spot" {
  ami           = var.ami_id
  instance_type = var.instance_type
  spot_price    = var.spot_price
  subnet_id     = aws_subnet.public_subnet[1].id
}
