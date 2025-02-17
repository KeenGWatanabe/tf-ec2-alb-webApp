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

#child module variables pass from root 
variable "ami_id" {
  type = string
}


