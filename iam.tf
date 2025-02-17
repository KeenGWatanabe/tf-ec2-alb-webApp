#IAM policy that allows access to rds # (item 1 _policy)
resource "aws_iam_policy" "ec2_access_policy" {
  name        = "ec2-access-policy"
  description = "Policy to allow access to rds"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ec2:Describe"]
        Resource = "*"
      }
    ]
  })
}

#IAM role created attach to ec2 policy #(item 1)
resource "aws_iam_role" "ec2_roger_role" {
  name = "ec2-roger_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
# (item 2) role_policy_attachment
resource "aws_iam_role_policy_attachment" "attach_ec2_policy" {
  role       = aws_iam_role.ec2_roger_role.name
  policy_arn = aws_iam_policy.ec2_access_policy.arn
} 

#attach IAM role to EC2 instance # (item 3_instance_profile)
resource "aws_iam_instance_profile" "ec2_roger_profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2_roger_role.name
}
#This policy allows describing and listing RDS resources without granting permissions to EC2.
data "aws_iam_policy_document" "policy_example" {
 statement {
   effect    = "Allow"
   actions   = ["ec2:Describe*"]
   resources = ["*"]
 }
}
resource "aws_instance" "web_app" {
  count         = var.settings.web_app.count
  instance_type = var.settings.web_app.instance_type
  ami           = data.aws_ami.amazon_linux.id #point to main.tf
  iam_instance_profile = aws_iam_instance_profile.ec2_roger_profile.name

  tags = {
    Name = "web-app-instance"
  }
}