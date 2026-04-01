output "bastion_sg_id" {
  description = "The ID of the Bastion security group"
  value       = aws_security_group.bastion.id
}

output "jenkins_sg_id" {
  description = "The ID of the Jenkins security group"
  value       = aws_security_group.jenkins.id
}

output "sonarqube_sg_id" {
  description = "The ID of the SonarQube security group"
  value       = aws_security_group.sonarqube.id
}
