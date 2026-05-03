# Bastion / EC2 / Auto Scaling 
variable "my_ip" {
  description = "My public IP address in CIDR format"
  type        = string
}

variable "key_name" {
  description = "The name of the key pair to use for the EC2 instance"
  type        = string
  default     = "vockey"
}


variable "instance_type" {
  description = "EC2 instance size for Webservers"
  type        = string
  default     = "t3.small"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

variable "asg_min_size" {
  description = "Minimum number of Webservers. Always at least this many will be running."
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum number of Webservers "
  type        = number
  default     = 3
}

variable "asg_desired_capacity" {
  description = "How many Webservers to run under normal conditions"
  type        = number
  default     = 2
}


# Database 

variable "db_username" {
  description = "MySQL admin username"
  type        = string
  default     = "petsearch_admin"
}

variable "db_password" {
  description = "MySQL admin password"
  type        = string
  sensitive   = true  
}


# Notifications 
variable "alert_email" {
  description = "Email address that receives PetSearch alerts"
  type        = string
}
