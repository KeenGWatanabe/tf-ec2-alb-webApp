#Creating the Key Pair
We will be creating a new key pair in our terraform directory. Run the following command:
"
ssh-keygen -t rsa -b 4096 -m pem -f roger_kp && openssl rsa -in roger_kp -outform pem && chmod 400 roger_kp.pem
"

updated:
ssh-keygen -t rsa -b 4096 -m pem -f roger_kp.pem && chmod 400 roger_kp.pem


An Elastic IP (EIP) in AWS is a static, public IPv4 address that you can allocate to your AWS account and associate with resources such as EC2 instances, NAT gateways, or network interfaces. Unlike a regular public IP address, which is dynamically assigned and can change when you stop/start an instance, an Elastic IP remains associated with your account until you explicitly release it.

Cost: AWS charges for Elastic IPs that are allocated but not associated with a running instance. Make sure to release unused Elastic IPs to avoid unnecessary costs.

Limits: By default, AWS allows up to 5 Elastic IPs per region per account. You can request a limit increase if needed.

Reassociation: You can reassociate an Elastic IP with another instance at any time.
