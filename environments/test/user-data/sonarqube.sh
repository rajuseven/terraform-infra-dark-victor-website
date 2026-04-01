#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get upgrade -y

# Install Docker
apt-get install -y docker.io
systemctl enable --now docker

# Add ubuntu user to docker group
usermod -aG docker ubuntu

# Create directories
mkdir -p /opt/sonarqube/{data,logs,extensions}
chmod -R 777 /opt/sonarqube

# Run SonarQube container
docker run -d --name sonarqube \
  -p 9000:9000 \
  -v /opt/sonarqube/data:/opt/sonarqube/data \
  -v /opt/sonarqube/logs:/opt/sonarqube/logs \
  -v /opt/sonarqube/extensions:/opt/sonarqube/extensions \
  sonarqube:9.9-community

# Logging
echo "SonarQube setup completed at $(date)" > /var/log/sonarqube-init.log
