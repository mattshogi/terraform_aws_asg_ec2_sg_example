
variable "region" {
  description = "AWS hosting region"
  default = "us-east-1"
}
variable "public_key_path" {
  description = "Enter the path to the SSH Public Key to add to AWS."
  default = ""
}
variable "key_name" {
  description = "Key name for SSHing into EC2"
  default = ""
}
variable "amis" {
  description = "Base AMI to launch the instances"
  default = {
  us-east-1 = "ami-713a6c1b"
  }
}
