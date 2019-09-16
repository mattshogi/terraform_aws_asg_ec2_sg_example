# Terraform Example: 
### Deploying EC2 Instances with Auto-Scaling, Load Balancing, and Security Groups
This is a quick example on how to use Terraform to deploy AWS Auto-Scaling EC2 instances with a load balancer, displaying a simple "Hello, World" page via httpd. The security groups created here are for displaying the page on the public internet, as well as allowing SSH traffic. The resources used here fall under the AWS Free tier. 

# Getting Started
### Packages
I am using Terraform version 0.12.7, and AWS-CLI version 1.16.230 (Python/2.7.10)

### Prerequisites
Make sure you have Terraform added to you $PATH so that you can run the commands in the directory where you store this repo. 

# Usage
Download the repo, navigate to the directory and run `terraform plan` and `terraform apply`. With a successful `terraform apply`, you will see the output for the 'elb_dns_name' and IP address where the site is displayed and can be verified. 

Although the instances created here are categorized in the AWS Free Tier, it is a good practice to run `terraform destroy` when you are finished running this example and no longer require these resources. 

# Acknowledgments
This example was developed using Ratul Basak's guide found here:
https://medium.com/@ratulbasak93/aws-elb-and-autoscaling-using-terraform-9999e6266734
