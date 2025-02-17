
# Security Group for the ALB
resource "aws_security_group" "webapp" {
  name_prefix = "${var.name_prefix}-webapp"
  description = "Allow traffic to webapp"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  # lifecycle {
  #   create_before_destroy = true
  # }
  tags = {
    Name = "${var.name_prefix}-web_app"
  }
}
# Application Load Balancer (ALB)
resource "aws_lb" "web_alb" {
  name               = "${var.name_prefix}-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webapp.id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "${var.name_prefix}-web-alb"
  }
}
# ALB Target Group
resource "aws_lb_target_group" "webapp" {
  name     = "${var.name_prefix}-webapp"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
    port     = 80
    protocol = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout  = 3
    interval = 5
  }
}
# Attach EC2 Instance to Target Group
resource "aws_lb_target_group_attachment" "webapp" {
  target_group_arn = aws_lb_target_group.webapp.arn
  target_id        = var.instance_id # Use the passed EC2 instance ID
  port             = 80
}

# ALB Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp.arn
  }
}
