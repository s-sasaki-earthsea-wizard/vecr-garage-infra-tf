variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "iam_role_arn" {
  description = "ARN of the IAM role for EC2 instances"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "Name of the IAM instance profile"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 20
}

variable "key_name" {
  description = "Name of the SSH key pair to use"
  type        = string
  default     = null
}

variable "ssh_allowed_cidr_blocks" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # This is not recommended for production
}

variable "create_elastic_ip" {
  description = "Whether to create and associate an Elastic IP"
  type        = bool
  default     = true
}

variable "detailed_monitoring_enabled" {
  description = "Whether to enable detailed monitoring"
  type        = bool
  default     = false
}