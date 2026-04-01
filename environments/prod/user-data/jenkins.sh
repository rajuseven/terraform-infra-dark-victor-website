#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get upgrade -y

# Install Java 17
apt-get install -y openjdk-17-jdk

# Install Docker
apt-get install -y docker.io
systemctl enable --now docker

# Add ubuntu user to docker group
usermod -aG docker ubuntu

# Install Jenkins dependencies
apt-get install -y wget gnupg lsb-release

# Add Jenkins repository
wget -q -O /usr/share/keyrings/jenkins-ci.gpg https://pkg.jenkins.io/debian-stable/jenkins.io.key || true
echo "deb [signed-by=/usr/share/keyrings/jenkins-ci.gpg] https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update and install Jenkins
apt-get update -y
apt-get install -y jenkins
systemctl enable --now jenkins

# Logging
echo "Jenkins setup completed at $(date)" > /var/log/jenkins-init.log
