The security group for an **EC2 instance** and a **web app** (e.g., hosted on AWS Elastic Beanstalk, ECS, or another service) can be similar, but they are not necessarily the same. It depends on the architecture and how the web app is deployed.

### Key Points:
1. **EC2 Instance Security Group**:
   - If your web app is running directly on an EC2 instance, the security group for the EC2 instance will control access to the web app.
   - To allow HTTP traffic, you would typically open **port 80 (HTTP)** and/or **port 443 (HTTPS)** in the security group's **inbound rules**.
   - Example inbound rule for HTTP:
     - Type: HTTP
     - Protocol: TCP
     - Port Range: 80
     - Source: `0.0.0.0/0` (for public access) or a specific IP range for restricted access.

2. **Web App Security Group**:
   - If your web app is hosted behind a load balancer (e.g., AWS Application Load Balancer or Elastic Load Balancer), the security group for the web app servers (e.g., EC2 instances or containers) might only allow traffic from the load balancer.
   - In this case, the load balancer's security group would allow ingress on port 80 (HTTP) or 443 (HTTPS), and the web app servers would only allow traffic from the load balancer's security group.
   - Example inbound rule for web app servers:
     - Type: Custom TCP
     - Protocol: TCP
     - Port Range: 80 (or the port your app listens on)
     - Source: [Load Balancer Security Group ID]

3. **Load Balancer Security Group**:
   - If you're using a load balancer, its security group would typically allow ingress on port 80 (HTTP) and/or 443 (HTTPS) from the internet (`0.0.0.0/0` or specific IP ranges).
   - Example inbound rule for the load balancer:
     - Type: HTTP
     - Protocol: TCP
     - Port Range: 80
     - Source: `0.0.0.0/0`

### Summary:
- If your web app is directly hosted on an EC2 instance, the EC2 security group will control access to the app, and you should open port 80 (and/or 443) for HTTP/HTTPS traffic.
- If your web app is behind a load balancer, the load balancer's security group will allow ingress on port 80/443, and the EC2 instances (or other compute resources) will only allow traffic from the load balancer.

Make sure to configure the security groups based on your specific architecture and security requirements.

ALB Security Group: Allows inbound traffic from the internet (port 80/443).

EC2 Security Group: Allows inbound traffic only from the ALB (using the ALB's security group as the source).