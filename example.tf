terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "all" {}

resource "aws_security_group" "instance" {
  name        = "terraform-example-instance"
  description = "Allow HTTP and SSH"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["YOUR_SSH_CIDR_HERE"] # Replace with your IP or variable
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "terraform-example-instance"
  }
}

resource "aws_launch_template" "example" {
  name_prefix   = "terraform-asg-example-"
  image_id      = lookup(var.amis, var.region)
  instance_type = "t2.micro"
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data     = base64encode(<<-EOF
    #!/bin/bash
    echo "Hello, World" > /var/www/html/index.html
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    EOF
  )
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "terraform-asg-example"
    }
  }
}

resource "aws_autoscaling_group" "example" {
  name                      = "terraform-asg-example"
  min_size                  = 2
  max_size                  = 10
  desired_capacity          = 2
  vpc_zone_identifier       = [] # Add subnet IDs here
  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }
  target_group_arns         = [aws_lb_target_group.example.arn]
  health_check_type         = "EC2"
  health_check_grace_period = 300
  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "elb" {
  name        = "terraform-example-elb"
  description = "Allow HTTP to ELB"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "terraform-example-elb"
  }
}

resource "aws_lb" "example" {
  name               = "terraform-asg-example"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb.id]
  subnets            = [] # Add subnet IDs here
  tags = {
    Name = "terraform-asg-example"
  }
}

resource "aws_lb_target_group" "example" {
  name     = "terraform-asg-example-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "" # Add your VPC ID here
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/"
    matcher             = "200"
  }
  tags = {
    Name = "terraform-asg-example-tg"
  }
}

resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }
}
