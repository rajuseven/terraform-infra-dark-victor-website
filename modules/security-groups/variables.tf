variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}

variable "your_public_ip" {
  description = "Your public IP address for SSH access (format: x.x.x.x/32)"
  type        = string
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/32$", var.your_public_ip))
    error_message = "Must be in CIDR format with /32 suffix (e.g., 192.168.1.1/32)"
  }
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}
