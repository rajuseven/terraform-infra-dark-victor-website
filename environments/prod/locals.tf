locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    CreatedAt   = timestamp()
  }

  # Friendly names for resources
  bastion_name   = "${var.environment}-bastion"
  jenkins_name   = "${var.environment}-jenkins"
  sonarqube_name = "${var.environment}-sonarqube"
}
