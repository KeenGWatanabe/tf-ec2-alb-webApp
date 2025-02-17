#!/bin/bash

# Exit on error
set -e

# Update system
sudo yum update -y

# Install Apache HTTP Server
sudo yum install httpd -y

# Enable and start httpd
sudo systemctl enable httpd
sudo systemctl start httpd

# Validate file_content variable
if [ -z "${file_content}" ]; then
  echo "Error: file_content variable is not set."
  exit 1
fi

# Create index.html
echo "${file_content}" > /var/www/html/index.html

# Configure URL rewriting
CUSTOM_CONF="/etc/httpd/conf.d/custom.conf"
if ! grep -q "RewriteEngine On" "$CUSTOM_CONF"; then
  echo 'RewriteEngine On' >> "$CUSTOM_CONF"
  echo 'RewriteRule ^/[a-zA-Z0-9]+[/]?$ /index.html [QSA,L]' >> "$CUSTOM_CONF"
fi

# Restart httpd to apply changes
sudo systemctl restart httpd

echo "Web server setup complete!"


# This script is useful for deploying a single-page application (SPA) or a static website where:

# All routes should serve the same index.html file (common in SPAs like React or Angular apps).

# The web server needs to be configured to handle dynamic-looking URLs without requiring actual backend routes.