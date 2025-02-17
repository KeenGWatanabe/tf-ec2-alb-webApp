# Security Group for ALB 
resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Allow HTTP/HTTPS traffic to ALB"
  vpc_id      = aws_vpc.roger_vpc.id # Replace with your VPC ID
     ingress {
     from_port   = 80
     to_port     = 80
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "alb-security-group"
  }
}
# Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false  # internet-facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.roger_public_subnet[*].id # Replace with your public subnet IDs
  enable_deletion_protection = false
  tags = {
    Name = "app-lb"
  }
}
# Target Group (routes traffic to ec2)
resource "aws_lb_target_group" "app_tg" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.roger_vpc.id # Replace with your VPC ID
  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
  tags = {
    Name = "app-target-group"
  }
}
# Attach EC2 Instance to Target Group
resource "aws_lb_target_group_attachment" "app_tg_attachment" {
  count = var.settings.web_app.count #match count of ec2
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.roger_web[count.index].id # Replace with your EC2 instance ID
  port             = 80
}
# ALB Listener (HTTP) fwd traffic to target grp
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
  tags = {
    Name = "app-listener"
  }
}

#if for (https) would need eip for fixed ip because of ARN call
# ALB Listener (HTTPS)
# resource "aws_lb_listener" "app_listener_https" {
#   load_balancer_arn = aws_lb.app_lb.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:acm:region:account-id:certificate/certificate-id" # Replace with your SSL certificate ARN
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.app_tg.arn
#   }
#   tags = {
#     Name = "app-listener-https"
#   }
# }