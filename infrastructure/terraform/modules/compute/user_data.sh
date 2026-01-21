#!/bin/bash
set -eux

# Update system
apt-get update -y

# Ensure Python is installed (Ansible requirement)
apt-get install -y python3 python3-pip

# Install required packages
apt-get install -y curl unzip

# Enable & start SSM Agent (Ubuntu usually has it preinstalled)
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# (Optional) Install Ansible for local execution/debug
pip3 install ansible

# Mark instance as ready
echo "ANSIBLE_READY=true" > /etc/ansible_ready