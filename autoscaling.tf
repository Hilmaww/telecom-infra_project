resource "aws_launch_template" "telecom_lt" {
  name          = "telecom-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.allow_http_ssh.id]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "telecom_asg" {
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  vpc_zone_identifier  = [aws_subnet.public_subnet[*].id]
  launch_template {
    id      = aws_launch_template.telecom_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "telecom-instance"
    propagate_at_launch = true
  }
}

resource "aws_lb" "telecom_lb" {
  name               = "telecom-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http_ssh.id]
  subnets            = aws_subnet.public_subnet[*].id
}

resource "aws_lb_target_group" "telecom_tg" {
  name        = "telecom-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.telecom_vpc.id
  target_type = "instance"
}

resource "aws_lb_listener" "telecom_listener" {
  load_balancer_arn = aws_lb.telecom_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.telecom_tg.arn
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.telecom_asg.id
  lb_target_group_arn    = aws_lb_target_group.telecom_tg.arn
}
