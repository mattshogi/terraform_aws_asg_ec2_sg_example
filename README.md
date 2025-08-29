# Terraform Example: Modern AWS EC2 Auto-Scaling with ALB

This example demonstrates how to use Terraform (v1.x+) to deploy AWS EC2 instances in an Auto Scaling Group behind an Application Load Balancer (ALB), with security groups and tagging. The instances serve a simple "Hello, World" page via Apache httpd.

## Getting Started

### Prerequisites
- Terraform >= 1.0.0
- AWS CLI >= 2.x
- Configure your AWS credentials (`aws configure`)

### Usage
1. Clone the repo and navigate to the directory.
2. Edit variables in `variable.tf` as needed (especially `key_name`, subnet IDs, VPC ID, and SSH CIDR).
3. Run `terraform init`, `terraform plan`, and `terraform apply`.
4. On success, the output will show the ALB DNS name where the site is available.

**Security Note:**  
Restrict SSH access to your IP address only. Always destroy resources (`terraform destroy`) when finished to avoid charges.

## Modernizations
- Uses Terraform 1.x and AWS provider 4.x+
- Application Load Balancer (ALB) replaces Classic ELB
- Launch Template replaces Launch Configuration
- Improved variable typing and validation
- Enhanced tagging and security group rules

## Acknowledgments
Originally inspired by Ratul Basak's guide:  
https://medium.com/@ratulbasak93/aws-elb-and-autoscaling-using-terraform-9999e6266734
