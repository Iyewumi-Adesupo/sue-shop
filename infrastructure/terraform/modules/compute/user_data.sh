#!/bin/bash
set -eux

# Update system
apt-get update -y

# Install Python & dependencies
apt-get install -y python3 python3-pip curl unzip git

# Ensure SSM Agent is running
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# Install Ansible
pip3 install ansible amazon.aws boto3 botocore

# Clone infrastructure repo (adjust repo URL)
mkdir -p /opt/ansible
cd /opt/ansible
git clone https://github.com/Iyewumi-Adesupo/sue-shop.git .

# Run Ansible locally using SSM-safe connection
cd ansible
ansible-playbook playbooks/site.yml

# Mark instance as configured
touch /etc/ansible_bootstrap_complete