output "web_public_ip" {
  description = "The public IP address of web server"
  value = aws_eip.roger_web_eip[0].public_ip
  depends_on = [ aws_eip.roger_web_eip ]
}
output "web_public_dns" {
  description = "The public DNS address of web server"
  value = aws_eip.roger_web_eip[0].public_dns
  depends_on = [aws_eip.roger_web_eip]
}

