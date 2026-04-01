# ============== VPC OUTPUTS ==============

output "vpc_id" {
  description = "The VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "The VPC CIDR block"
  value       = module.vpc.vpc_cidr
}

# Public Subnets
output "public_subnet_1_id" {
  description = "Public Subnet 1 ID"
  value       = module.vpc.public_subnet_1_id
}

output "public_subnet_1_cidr" {
  description = "Public Subnet 1 CIDR"
  value       = module.vpc.public_subnet_1_cidr
}

output "public_subnet_2_id" {
  description = "Public Subnet 2 ID"
  value       = module.vpc.public_subnet_2_id
}

output "public_subnet_2_cidr" {
  description = "Public Subnet 2 CIDR"
  value       = module.vpc.public_subnet_2_cidr
}

# Private Subnets
output "private_subnet_1_id" {
  description = "Private Subnet 1 ID"
  value       = module.vpc.private_subnet_1_id
}

output "private_subnet_1_cidr" {
  description = "Private Subnet 1 CIDR"
  value       = module.vpc.private_subnet_1_cidr
}

output "private_subnet_2_id" {
  description = "Private Subnet 2 ID"
  value       = module.vpc.private_subnet_2_id
}

output "private_subnet_2_cidr" {
  description = "Private Subnet 2 CIDR"
  value       = module.vpc.private_subnet_2_cidr
}

# Internet Gateway
output "internet_gateway_id" {
  description = "The Internet Gateway ID"
  value       = module.vpc.internet_gateway_id
}

# Route Tables
output "public_route_table_id" {
  description = "Public Route Table ID"
  value       = module.vpc.public_route_table_id
}

output "private_route_table_id" {
  description = "Private Route Table ID"
  value       = module.vpc.private_route_table_id
}

# ============== SECURITY GROUP OUTPUTS ==============

output "bastion_sg_id" {
  description = "Bastion Security Group ID"
  value       = module.security_groups.bastion_sg_id
}

output "jenkins_sg_id" {
  description = "Jenkins Security Group ID"
  value       = module.security_groups.jenkins_sg_id
}

output "sonarqube_sg_id" {
  description = "SonarQube Security Group ID"
  value       = module.security_groups.sonarqube_sg_id
}

# ============== BASTION OUTPUTS ==============

output "bastion_instance_id" {
  description = "Bastion EC2 Instance ID"
  value       = module.bastion.instance_id
}

output "bastion_public_ip" {
  description = "Bastion Public IP (Use this for SSH)"
  value       = module.bastion.public_ip
}

output "bastion_private_ip" {
  description = "Bastion Private IP"
  value       = module.bastion.private_ip
}

output "bastion_availability_zone" {
  description = "Bastion Availability Zone"
  value       = module.bastion.availability_zone
}

# ============== JENKINS OUTPUTS ==============

output "jenkins_instance_id" {
  description = "Jenkins EC2 Instance ID"
  value       = module.jenkins.instance_id
}

output "jenkins_private_ip" {
  description = "Jenkins Private IP (Access through Bastion)"
  value       = module.jenkins.private_ip
}

output "jenkins_availability_zone" {
  description = "Jenkins Availability Zone"
  value       = module.jenkins.availability_zone
}

# ============== SONARQUBE OUTPUTS ==============

output "sonarqube_instance_id" {
  description = "SonarQube EC2 Instance ID"
  value       = module.sonarqube.instance_id
}

output "sonarqube_private_ip" {
  description = "SonarQube Private IP (Access through Bastion)"
  value       = module.sonarqube.private_ip
}

output "sonarqube_availability_zone" {
  description = "SonarQube Availability Zone"
  value       = module.sonarqube.availability_zone
}

# ============== AWS ACCOUNT INFO ==============

output "aws_account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS Region"
  value       = data.aws_region.current.name
}

# ============== CONNECTION GUIDE ==============

output "ssh_bastion_command" {
  description = "SSH command to connect to Bastion"
  value       = "ssh -i /path/to/key.pem ec2-user@${module.bastion.public_ip}"
}

output "ssh_jenkins_via_bastion" {
  description = "SSH command to connect to Jenkins via Bastion"
  value       = "ssh -i /path/to/key.pem -J ec2-user@${module.bastion.public_ip} ec2-user@${module.jenkins.private_ip}"
}

output "ssh_sonarqube_via_bastion" {
  description = "SSH command to connect to SonarQube via Bastion"
  value       = "ssh -i /path/to/key.pem -J ec2-user@${module.bastion.public_ip} ec2-user@${module.sonarqube.private_ip}"
}

output "jenkins_port_forward_command" {
  description = "Command to port forward Jenkins UI (9000) through Bastion"
  value       = "ssh -i /path/to/key.pem -L 8080:${module.jenkins.private_ip}:8080 -J ec2-user@${module.bastion.public_ip} ec2-user@${module.jenkins.private_ip}"
}

output "sonarqube_port_forward_command" {
  description = "Command to port forward SonarQube UI (9000) through Bastion"
  value       = "ssh -i /path/to/key.pem -L 9000:${module.sonarqube.private_ip}:9000 -J ec2-user@${module.bastion.public_ip} ec2-user@${module.sonarqube.private_ip}"
}
