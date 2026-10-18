# 🏗️ Production AWS Infrastructure as Code (IaC) Platform with Terraform & CI/CD

[![Terraform](https://img.shields.io/badge/IaC-Terraform%20v1.7%2B-844FBA?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/Cloud-Amazon%20Web%20Services-232F3E?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Region](https://img.shields.io/badge/Region-ap--south--1%20(Mumbai)-FF9900)](https://aws.amazon.com/about-aws/global-infrastructure/regions_az/)
[![Security](https://img.shields.io/badge/Security-tfsec%20Scanned-green)](https://aquasecurity.github.io/tfsec/)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?logo=githubactions&logoColor=white)](https://github.com/features/actions)

> **Architected & Engineered by:** [Chiranjibee Panigrahi](https://github.com/Chiranjibee18)  
> **Role Alignment:** AWS DevOps Engineer | Cloud Infrastructure Engineer | Platform Automation  
> **Status:** Fully Modularized, Linted, Security Hardened, and Multi-Environment Verified  

---

## 📌 Architecture & Infrastructure Topology

```
================================ AWS REGION: ap-south-1 ================================

                           [ Internet / End Users ]
                                      │
                                      ▼
                           [ Internet Gateway (IGW) ]
                                      │
     ┌────────────────────────────────┴────────────────────────────────┐
     │ PUBLIC SUBNETS (Multi-AZ)                                       │
     │                                                                 │
     │   [ Public Subnet 1 ]                       [ Public Subnet 2 ] │
     │   CIDR: 10.0.1.0/24                         CIDR: 10.0.2.0/24   │
     │                                                                 │
     │   ┌─────────────────────────────────────────────────────────┐   │
     │   │      Application Load Balancer (ALB) — HTTP:80          │   │
     │   └────────────────────────────┬────────────────────────────┘   │
     │                                │                                │
     │   [ NAT Gateway + EIP ]        │                                │
     └─────────────┬──────────────────┼────────────────────────────────┘
                   │                  │
                   │ Route 0.0.0.0/0  │ HTTP forward (Port 80/3000)
                   ▼                  ▼
     ┌─────────────────────────────────────────────────────────────────┐
     │ PRIVATE SUBNETS (Isolated Workloads)                            │
     │                                                                 │
     │   [ Private Subnet 1 ]                      [ Private Subnet 2 ]│
     │   CIDR: 10.0.11.0/24                        CIDR: 10.0.12.0/24  │
     │                                                                 │
     │   ┌─────────────────────────────────────────────────────────┐   │
     │   │     Auto Scaling Group (ASG: Min 2, Max 6)              │   │
     │   │     Target Tracking Policy (Maintains 60% CPU)          │   │
     │   │     Amazon Linux 2023 + Zero SSH Ports (AWS SSM)        │   │
     │   └─────────────────────────────────────────────────────────┘   │
     └─────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
                      ┌────────────────────────────────┐
                      │    Encrypted S3 Asset Store    │
                      │    AES256 + Public Access Block│
                      └────────────────────────────────┘
```

---

## 🔑 Core Engineering Highlights

### 1. Highly Modular & Reusable Structure
- **De-coupled Architecture:** Each infrastructure domain is isolated into dedicated modules:
  - `modules/vpc`: Multi-AZ VPC, subnets, NAT Gateway, IGW, and explicit route tables.
  - `modules/security`: Granular Security Groups enforcing the principle of least privilege.
  - `modules/compute`: Application Load Balancer, Launch Templates, and Auto Scaling Groups.
  - `modules/iam`: AWS Systems Manager (SSM) roles enabling keyless terminal access.
  - `modules/storage`: Encrypted, versioned S3 buckets with complete public access blocks.
- **Environment Separation:** Complete isolation between `environments/dev/` and `environments/prod/` with parameterized variables.

### 2. Zero-Trust Security Design
- **No Direct Internet Access for Compute:** EC2 instances live strictly in private subnets with **no public IPs**. Outbound internet access (for package updates) flows strictly through a managed **NAT Gateway**.
- **Chained Security Groups:** The compute security group does **not** allow arbitrary inbound CIDRs. Inbound HTTP port 80/3000 is allowed **strictly from the ALB Security Group ID** (`security_groups = [aws_security_group.alb.id]`).
- **Keyless Management (No Open Port 22):** SSH port 22 is completely closed. Administrators access instances via **AWS Systems Manager (SSM) Session Manager**, backed by IAM instance profiles.

### 3. State Management & Distributed Locking
- **Remote S3 Backend:** State is stored in a centralized, versioned, and AES256-encrypted S3 bucket (`prevent_destroy = true`).
- **DynamoDB Distributed Locking:** Concurrency conflicts and team race conditions are eliminated using a DynamoDB table with partition key `LockID`.

### 4. CI/CD & Automated Security Validation
- **GitHub Actions Pipeline:** Automatically triggers on pull requests to run:
  - `terraform fmt -check` (Enforces standard code formatting)
  - `terraform validate` (Validates configuration syntax and references)
  - `tfsec` (Static security analysis identifying unencrypted disks or permissive ingress rules)

---

## 📂 Repository Directory Layout

```text
aws-terraform-infrastructure-platform/
├── .github/workflows/
│   └── terraform.yml            # CI/CD validation, linting & tfsec security scanning
├── backend-setup/
│   └── main.tf                  # Provisions S3 state storage & DynamoDB lock table
├── modules/
│   ├── vpc/                     # VPC, Multi-AZ subnets, NAT Gateway, Route Tables
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security/                # ALB & Compute chained Security Groups
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── compute/                 # ALB, Target Groups, Launch Template, Auto Scaling Group
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── iam/                     # EC2 SSM Role & Instance Profile
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── storage/                 # Encrypted S3 bucket with Public Access Block
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── environments/
    └── dev/                     # Development environment orchestration
        ├── main.tf
        ├── variables.tf
        ├── terraform.tfvars
        └── outputs.tf
```

---

## 🚀 Step-by-Step Deployment Walkthrough

### Step 1: Provision Remote State Storage & DynamoDB Lock Table
```bash
cd backend-setup/
terraform init
terraform apply -auto-approve
```

### Step 2: Deploy the Development Environment
```bash
cd ../environments/dev/

# Initialize Terraform (fetches modules & providers)
terraform init

# Validate configuration
terraform validate

# Review the speculative execution plan
terraform plan

# Apply the infrastructure
terraform apply
```

### Step 3: Access & Validate the Load Balancer
Upon completion, Terraform outputs the public ALB DNS name:
```bash
# Output sample:
# alb_public_url = "http://dev-alb-123456789.ap-south-1.elb.amazonaws.com"

curl $(terraform output -raw alb_public_url)
```

---

## 🎓 Technical Interview Defense (FAQ)

### Q1: Why do we use DynamoDB alongside S3 for remote state?
> **Answer:** S3 provides durable remote storage and versioning for `terraform.tfstate`, but S3 does not offer atomic write locks. If two engineers (or an engineer and a CI/CD pipeline) run `terraform apply` concurrently, state corruption can occur. DynamoDB uses the `LockID` primary key to acquire an atomic lock before any write operation and releases it after completion.

### Q2: Why is chaining Security Groups better than CIDR whitelisting?
> **Answer:** In cloud auto-scaling architectures, backend instances have dynamic private IPs. Hardcoding CIDR ranges like `10.0.0.0/16` allows *any* resource in the VPC to access the app. Referencing the ALB's Security Group ID (`security_groups = [aws_security_group.alb.id]`) ensures that **only packets originating from the load balancer itself** are admitted by the hypervisor network filter.

### Q3: What is the difference between `create_before_destroy` in Launch Templates vs default lifecycle?
> **Answer:** By default, Terraform destroys a resource before creating its replacement. For an Auto Scaling Launch Template, destroying the template first would temporarily break the ASG. `create_before_destroy = true` forces Terraform to provision the new Launch Template version first, update the ASG reference, and only then tear down the deprecated template, preventing deployment downtime.

---

## 📜 License
This project is open-source and licensed under the MIT License.
