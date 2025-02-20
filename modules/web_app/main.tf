


# EC2 instance for the web application
resource "aws_instance" "web_app" {
  ami                    = var.ami_id # Replace with your desired AMI ID
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_ids[0] # Use the first public subnet
  vpc_security_group_ids = [var.web_app_sg_id]
  key_name               = var.key_name
  user_data              = templatefile("${path.module}/init-script.sh", {
    file_content = "webapp"
  })
  
  tags = {
    Name = "web-app-instance"
  }
}

# Attach the EC2 instance to the ALB target group
resource "aws_lb_target_group_attachment" "web_app" {
  target_group_arn = var.alb_target_group_arn
  target_id        = aws_instance.web_app.id
  port             = 80
}