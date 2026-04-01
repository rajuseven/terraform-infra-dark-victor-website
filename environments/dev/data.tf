# Data sources for the dev environment
# Currently all AMI lookups are handled within the EC2 module

# Example: Get current AWS account ID (for reference)
data "aws_caller_identity" "current" {}

# Example: Get current AWS region details (for reference)
data "aws_region" "current" {}
