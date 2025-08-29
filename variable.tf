variable "region" {
  description = "AWS hosting region"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "Key name for SSHing into EC2"
  type        = string
  default     = ""
}

variable "amis" {
  description = "Base AMI to launch the instances"
  type        = map(string)
  default     = {
    us-east-1 = "ami-0c02fb55956c7d316" # Amazon Linux 2 (latest public)
  }
}
