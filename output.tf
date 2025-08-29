output "asg_instance_ids" {
  value = aws_autoscaling_group.example.id
}

output "alb_dns_name" {
  value = aws_lb.example.dns_name
}