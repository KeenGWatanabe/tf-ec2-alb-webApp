#3 subnets
data "aws_availability_zones" "available" {
  state = "available"
}
# Fetching my_ip code
data "http" "my_public_ip" {
  url = "https://ifconfig.me/ip" # or use any other service that returns your public IP
}

# Define a local value for the public IP
locals {
  my_public_ip = "${data.http.my_public_ip.response_body}/32"
}

# Output the my_ip value
output "my_ip" {
  value = local.my_public_ip
}

