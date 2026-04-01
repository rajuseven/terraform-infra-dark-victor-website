# Get the latest Ubuntu 22.04 LTS (Jammy) AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Create EC2 Instance
resource "aws_instance" "instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  # Security group
  vpc_security_group_ids = [var.security_group_id]

  # Use IMDSv2 only (more secure)
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"  # Require IMDSv2
    http_put_response_hop_limit = 1
  }

  # Root volume configuration
  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.volume_size
    encrypted             = true
    delete_on_termination = true

    tags = merge(
      var.common_tags,
      {
        Name = "${var.instance_name}-root-volume"
      }
    )
  }

  # Assign public IP if specified (for Bastion)
  associate_public_ip_address = var.assign_public_ip

  # Key pair name for SSH
  key_name = var.key_pair_name

  # User data for bootstrapping
  user_data = base64encode(var.user_data)

  # Monitoring
  monitoring = true

  tags = merge(
    var.common_tags,
    {
      Name = var.instance_name
    }
  )
}
