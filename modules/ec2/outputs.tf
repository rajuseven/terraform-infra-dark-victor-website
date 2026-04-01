output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.instance.id
}

output "instance_arn" {
  description = "The ARN of the instance"
  value       = aws_instance.instance.arn
}

output "private_ip" {
  description = "The private IP address of the instance"
  value       = aws_instance.instance.private_ip
}

output "public_ip" {
  description = "The public IP address of the instance (if assigned)"
  value       = aws_instance.instance.public_ip
}

output "availability_zone" {
  description = "The availability zone of the instance"
  value       = aws_instance.instance.availability_zone
}

output "ami_id" {
  description = "The AMI ID used for the instance"
  value       = aws_instance.instance.ami
}

output "security_groups" {
  description = "The security groups assigned to the instance"
  value       = aws_instance.instance.vpc_security_group_ids
}
