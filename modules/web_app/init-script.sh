#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl enable httpd
sudo systemctl start httpd
echo "${file_content}" | sudo tee /var/www/html/index.html > /dev/null
echo 'RewriteEngine On' | sudo tee -a /etc/httpd/conf.d/custom.conf > /dev/null
echo 'RewriteRule ^/[a-zA-Z0-9]+[/]?$ /index.html [QSA,L]' | sudo tee -a /etc/httpd/conf.d/custom.conf > /dev/null
sudo systemctl restart httpd