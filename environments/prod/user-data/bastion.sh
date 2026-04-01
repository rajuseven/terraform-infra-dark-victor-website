#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get upgrade -y

# Install essential tools
apt-get install -y curl git docker.io unzip wget
systemctl enable --now docker

# Add ubuntu user to docker group
usermod -aG docker ubuntu

# Logging
echo "Bastion setup completed at $(date)" > /var/log/bastion-init.log
