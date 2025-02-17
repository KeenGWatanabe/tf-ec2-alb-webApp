
# User data script to install and start HTTPD
data "template_file" "init_script" {
  template = file("${path.module}/init-script.sh")
  
  vars = {
    file_content = "Hello, World! This is the web app content." # Replace with your desired content
  }
}


# EC2 instance for the web application
resource "aws_instance" "web_app" {
  ami                    = var.ami_id # Replace with your desired AMI ID
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_ids[0] # Use the first public subnet
  vpc_security_group_ids = [var.web_app_sg_id]
  key_name               = var.key_name
  user_data              = data.template_file.init_script.rendered

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