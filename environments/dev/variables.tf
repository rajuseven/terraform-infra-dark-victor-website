variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "devsecops"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "your_public_ip" {
  description = "Your public IP address for SSH access (format: x.x.x.x/32)"
  type        = string
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/32$", var.your_public_ip))
    error_message = "Must be in CIDR format with /32 suffix (e.g., 192.168.1.1/32)"
  }
}

variable "key_pair_name" {
  description = "Name of the EC2 key pair for SSH access"
  type        = string
}

variable "bastion_instance_type" {
  description = "Instance type for Bastion host"
  type        = string
  default     = "t2.micro"
}

variable "bastion_volume_size" {
  description = "Volume size for Bastion host in GB"
  type        = number
  default     = 20
}

variable "jenkins_instance_type" {
  description = "Instance type for Jenkins server"
  type        = string
  default     = "t2.large"
}

variable "jenkins_volume_size" {
  description = "Volume size for Jenkins server in GB"
  type        = number
  default     = 25
}

variable "sonarqube_instance_type" {
  description = "Instance type for SonarQube server"
  type        = string
  default     = "t2.micro"
}

variable "sonarqube_volume_size" {
  description = "Volume size for SonarQube server in GB"
  type        = number
  default     = 12
}
