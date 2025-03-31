# ------------------------------------------------------------
# AWS Configuration
# ------------------------------------------------------------

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-northeast-1"
}

# ------------------------------------------------------------
# Environment Configuration
# ------------------------------------------------------------

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}

# ------------------------------------------------------------
# OpenAI Configuration
# ------------------------------------------------------------

variable "openai_api_key" {
  description = "OpenAI API Key"
  type        = string
  sensitive   = true
}

# ------------------------------------------------------------
# EC2 Configuration
# ------------------------------------------------------------

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair to use"
  type        = string
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
}

variable "create_elastic_ip" {
  description = "Whether to create and associate an Elastic IP"
  type        = bool
}

variable "detailed_monitoring_enabled" {
  description = "Whether to enable detailed monitoring"
  type        = bool
}

# ------------------------------------------------------------
# Secrets Manager Configuration
# ------------------------------------------------------------

variable "secrets_version" {
  description = "Secrets version"
  type        = string
}

# ------------------------------------------------------------
# Networking Configuration
# ------------------------------------------------------------

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}

variable "create_nat_gateway" {
  description = "Create NAT gateway"
  type        = bool
  default     = false
}

# ------------------------------------------------------------
# Security Configuration
# ------------------------------------------------------------

variable "ssh_allowed_cidr_blocks" {
  description = "Allowed CIDR blocks for SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
