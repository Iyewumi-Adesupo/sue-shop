
Sue-Shop – Cloud-Native E-commerce Platform

Sue-Shop is a full-stack e-commerce platform designed to demonstrate production-grade cloud infrastructure, DevOps automation, and secure-by-design architecture.
The project combines Django + React, Docker, Terraform, Ansible, and AWS to model a real-world, scalable system.

⸻

High-Level Architecture
	•	Frontend: React (containerised)
	•	Backend: Django REST API (containerised)
	•	Infrastructure: AWS provisioned with Terraform
	•	Configuration Management: Ansible
	•	Networking: VPC, public/private subnets, ALB, Route53
	•	Security: IAM roles, Security Groups, Secrets Manager, WAF
	•	State Management: Remote Terraform state (S3 backend)
	•	CI/CD Ready: GitHub Actions compatible (no local profiles hardcoded)

⸻

Repository Structure
**code**

sue-shop/
├── .github/                  # GitHub Actions workflows
├── ansible/                  # Ansible playbooks & roles
│   ├── playbooks/
│   └── roles/
├── backend/                  # Django backend application
├── frontend/                 # React frontend application
├── infrastructure/
│   └── terraform/
│       ├── backend.tf        # Remote state backend configuration
│       ├── backend-config.tf # Backend variables
│       ├── provider.tf       # AWS provider configuration
│       ├── main.tf           # Root module wiring
│       ├── variables.tf      # Root variables
│       ├── outputs.tf        # Root outputs
│       ├── terraform.tfvars  # Environment values (not committed)
│       └── modules/
│           ├── networking/   # VPC, subnets, routes, ALB, Route53, ACM
│           ├── security/     # IAM, SGs, WAF, Secrets Manager
│           ├── compute/      # Launch Template, Auto Scaling Group
│           ├── database/     # RDS PostgreSQL (private subnets)
│           └── storage/      # S3, CloudFront, lifecycle, logging
├── docker-compose.yml        # Local development stack
├── docker-compose.prod.yml   # Production container layout
├── Makefile                  # Common automation commands
└── README.md

Infrastructure Design (Terraform)

Networking Module
	•	Custom VPC
	•	Public & private subnets across multiple AZs
	•	Internet Gateway & NAT Gateway
	•	Application Load Balancer (ALB)
	•	Route53 DNS records
	•	ACM certificates (DNS validation)

Compute Module
	•	Launch Template (no standalone EC2)
	•	Auto Scaling Group (private subnets only)
	•	ALB target group attachment
	•	IAM Instance Profile
	•	SSM Session Manager access (no SSH)

Security Module
	•	Security Groups (ALB, EC2, RDS)
	•	IAM roles and least-privilege policies
	•	AWS Secrets Manager (DB credentials)
	•	AWS WAF (rate limiting + logging)
	•	CloudWatch alarms for WAF metrics

Database Module
	•	RDS PostgreSQL
	•	Private subnet group
	•	No public access
	•	Credentials sourced from Secrets Manager

Storage Module
	•	S3 bucket for static assets
	•	Versioning, encryption, lifecycle rules
	•	Access logging bucket
	•	CloudFront distribution
	•	WAF attached at CloudFront edge

⸻

Configuration Management (Ansible)

Ansible is used after infrastructure provisioning to configure instances created by the Auto Scaling Group.

Responsibilities:
	•	Install Docker & Docker Compose
	•	Install and configure Nginx
	•	Prepare host for container workloads
	•	Designed to be triggered via:
	•	SSM Session Manager
	•	CI/CD pipelines (GitHub Actions)

Ansible is kept separate from Terraform to maintain clean separation of concerns:
	•	Terraform → infrastructure
	•	Ansible → system configuration

⸻

State Management & Security
	•	Terraform state stored remotely in S3
	•	State locking via DynamoDB (if enabled)
	•	No .tfstate or .tfvars committed to Git
	•	AWS credentials injected via CI/CD (OIDC ready)
	•	No hardcoded secrets in codebase

⸻

Deployment Workflow (Planned / Supported)
	1.	Terraform Apply
	•	Provisions AWS infrastructure
	2.	Ansible Bootstrap
	•	Configures compute instances
	3.	CI/CD Pipeline
	•	Builds Docker images
	•	Pushes to registry
	•	Triggers rolling updates via ASG

⸻

Why This Architecture?

This project demonstrates:
	•	Infrastructure as Code (IaC)
	•	Secure-by-design cloud architecture
	•	Scalable, production-ready patterns
	•	Clear separation between infra, config, and app
	•	Real-world DevOps workflows aligned with industry standards
