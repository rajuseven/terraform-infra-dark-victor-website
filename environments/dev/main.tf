# ============== VPC MODULE ==============
module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr    = var.vpc_cidr
  environment = var.environment
  common_tags = local.common_tags
}

# ============== SECURITY GROUPS MODULE ==============
module "security_groups" {
  source = "../../modules/security-groups"

  vpc_id         = module.vpc.vpc_id
  environment    = var.environment
  your_public_ip = var.your_public_ip
  common_tags    = local.common_tags
}

# ============== EC2 BASTION MODULE ==============
module "bastion" {
  source = "../../modules/ec2"

  instance_name     = local.bastion_name
  instance_type     = var.bastion_instance_type
  subnet_id         = module.vpc.public_subnet_1_id
  security_group_id = module.security_groups.bastion_sg_id
  volume_size       = var.bastion_volume_size
  assign_public_ip  = true
  key_pair_name     = var.key_pair_name
  user_data         = file("${path.module}/user-data/bastion.sh")
  common_tags       = local.common_tags

  depends_on = [module.vpc, module.security_groups]
}

# ============== EC2 JENKINS MODULE ==============
module "jenkins" {
  source = "../../modules/ec2"

  instance_name     = local.jenkins_name
  instance_type     = var.jenkins_instance_type
  subnet_id         = module.vpc.private_subnet_1_id
  security_group_id = module.security_groups.jenkins_sg_id
  volume_size       = var.jenkins_volume_size
  assign_public_ip  = false
  key_pair_name     = var.key_pair_name
  user_data         = file("${path.module}/user-data/jenkins.sh")
  common_tags       = local.common_tags

  depends_on = [module.vpc, module.security_groups, module.bastion]
}

# ============== EC2 SONARQUBE MODULE ==============
module "sonarqube" {
  source = "../../modules/ec2"

  instance_name     = local.sonarqube_name
  instance_type     = var.sonarqube_instance_type
  subnet_id         = module.vpc.private_subnet_2_id
  security_group_id = module.security_groups.sonarqube_sg_id
  volume_size       = var.sonarqube_volume_size
  assign_public_ip  = false
  key_pair_name     = var.key_pair_name
  user_data         = file("${path.module}/user-data/sonarqube.sh")
  common_tags       = local.common_tags

  depends_on = [module.vpc, module.security_groups, module.bastion]
}
