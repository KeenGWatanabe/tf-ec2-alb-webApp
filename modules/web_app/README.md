To create a `modules/web_app/main.tf` for an HTTPD web application using the existing ALB and security groups from your root `main.tf`, you need to modularize the components specific to the web application. This includes the EC2 instance, the user data script for HTTPD, and any associated resources. Below is an example of what you might include in `modules/web_app/main.tf`:

### `modules/web_app/main.tf`

```hcl
# Define variables for the module
variable "vpc_id" {
  description = "The VPC ID where the web app will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the EC2 instance"
  type        = list(string)
}

variable "alb_target_group_arn" {
  description = "The ARN of the ALB target group to which the EC2 instance will be attached"
  type        = string
}

variable "web_app_sg_id" {
  description = "The security group ID for the web application"
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key pair name for SSH access"
  type        = string
}

# User data script to install and start HTTPD
data "template_file" "init_script" {
  template = file("${path.module}/init-script.sh")
}

# EC2 instance for the web application
resource "aws_instance" "web_app" {
  ami                    = "ami-0c55b159cbfafe1f0" # Replace with your desired AMI ID
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
```

### Explanation:
1. **Variables**:
   - `vpc_id`: The VPC ID where the resources will be deployed.
   - `public_subnet_ids`: The list of public subnet IDs for the EC2 instance.
   - `alb_target_group_arn`: The ARN of the ALB target group to attach the EC2 instance.
   - `web_app_sg_id`: The security group ID for the web application.
   - `instance_type`: The EC2 instance type (default is `t2.micro`).
   - `key_name`: The key pair name for SSH access.

2. **User Data Script**:
   - The `template_file` data source reads the `init-script.sh` file, which contains the commands to install and configure HTTPD on the EC2 instance.

3. **EC2 Instance**:
   - The `aws_instance` resource creates an EC2 instance in the specified public subnet, attaches the security group, and uses the user data script to configure HTTPD.

4. **ALB Target Group Attachment**:
   - The `aws_lb_target_group_attachment` resource attaches the EC2 instance to the ALB target group.

### `init-script.sh`
Place the `init-script.sh` file in the `modules/web_app` directory. Here’s an example of what it might look like:

```bash
#!/bin/bash
# Install HTTPD
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# Create a simple index.html file
echo "<html><body><h1>Hello, World!</h1></body></html>" > /var/www/html/index.html
```

### Usage in Root `main.tf`
In your root `main.tf`, call the `web_app` module like this:

```hcl
module "web_app" {
  source = "./modules/web_app"

  vpc_id               = aws_vpc.main.id
  public_subnet_ids    = aws_subnet.public[*].id
  alb_target_group_arn = aws_lb_target_group.web_app.arn
  web_app_sg_id        = aws_security_group.web_app.id
  instance_type        = "t2.micro"
  key_name             = "your-key-pair-name"
}
```

### Key Points:
- The `web_app` module is reusable and encapsulates the web application logic.
- The root `main.tf` passes the necessary variables (e.g., VPC ID, subnet IDs, ALB target group ARN, etc.) to the module.
- The `init-script.sh` is used to configure the EC2 instance with HTTPD.

This approach keeps your infrastructure code modular, reusable, and easier to maintain.