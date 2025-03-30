variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "secret_name" {
  description = "Name of the secret"
  type        = string
}

variable "description" {
  description = "Description of the secret"
  type        = string
  default     = "Managed by Terraform"
}

variable "recovery_window_in_days" {
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret"
  type        = number
  default     = 30
}

variable "secret_value" {
  description = "Value for the secret as a string (either this or secret_map should be provided)"
  type        = string
  default     = null
  sensitive   = true
}

variable "secret_map" {
  description = "Map of values for the secret (either this or secret_value should be provided)"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "create_access_policy" {
  description = "Whether to create an IAM policy for accessing this secret"
  type        = bool
  default     = true
}