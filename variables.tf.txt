variable "aws_region" {
  description = "The AWS region to deploy the infrastructure"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instances"
  default     = "ami-0c55b159cbfafe1f0"  # Example: Amazon Linux 2
}

variable "desired_capacity" {
  description = "Desired capacity of the Auto Scaling group"
  default     = 2
}

variable "max_size" {
  description = "Maximum size of the Auto Scaling group"
  default     = 5
}

variable "min_size" {
  description = "Minimum size of the Auto Scaling group"
  default     = 1
}

variable "spot_price" {
  description = "Maximum price for spot instances"
  default     = "0.015"
}
