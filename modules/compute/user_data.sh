#!/bin/bash
set -eux

### --- System bootstrap ---
apt-get update -y

# Core packages
apt-get install -y \
  python3 \
  python3-pip \
  curl \
  unzip \
  git \
  ca-certificates \
  gnupg \
  lsb-release

### --- SSH hardening basics ---
# Ensure SSH is running (it is by default on Ubuntu, but explicit is safer)
systemctl enable ssh
systemctl start ssh

# Disable root login (best practice)
sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl reload ssh

### --- Docker (if needed by your app) ---
apt-get install -y docker.io docker-compose-plugin
systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

### --- Optional: Python tooling for Ansible (REMOTE side only) ---
# (Ansible itself runs from your laptop, not here)
pip3 install --no-cache-dir \
  boto3 \
  botocore

### --- Marker file (useful for debugging / idempotency) ---
touch /etc/ssh_bootstrap_complete