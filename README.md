# Terraform AWS DevSecOps Infrastructure (Raju Edition)

A beginner-friendly yet organization-grade Terraform project to provision AWS infrastructure for a DevSecOps pipeline with Bastion, Jenkins, and SonarQube servers.

## 📋 Project Overview

This Terraform project creates a complete AWS infrastructure with:
- Custom VPC with public and private subnets across 2 availability zones
- Bastion host for secure access to private resources
- Jenkins server for CI/CD pipelines
- SonarQube server for code quality analysis
- Proper security groups with restricted access
- No NAT Gateway (for cost optimization in dev environment)

## 🏗️ Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         AWS Account (ap-south-1)               │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    VPC (10.0.0.0/16)                    │  │
│  │                                                          │  │
│  │  ┌────────────────────────────────────────────────────┐ │  │
│  │  │            Internet Gateway (IGW)                 │ │  │
│  │  └────────────────────────────────────────────────────┘ │  │
│  │                        │                                │  │
│  │  ┌─────────────────────┴──────────────────────────────┐ │  │
│  │  │         Public Route Table (0.0.0.0/0 → IGW)      │ │  │
│  │  └──────┬──────────────────────────────┬──────────────┘ │  │
│  │         │                              │                │  │
│  │  ┌──────▼──────────────┐       ┌───────▼──────────┐    │  │
│  │  │  Public Subnet 1    │       │ Public Subnet 2  │    │  │
│  │  │ 10.0.1.0/24 (AZ-1a) │       │10.0.2.0/24(AZ-1b)│   │  │
│  │  │                      │       │                  │    │  │
│  │  │  ┌────────────────┐  │       │                  │    │  │
│  │  │  │ Bastion Host   │  │       │   (Reserved)     │    │  │
│  │  │  │ (t2.medium)     │  │       │   (for future)   │    │  │
│  │  │  │ + Public IP    │  │       │                  │    │  │
│  │  │  └────────────────┘  │       │                  │    │  │
│  │  └──────────────────────┘       └──────────────────┘    │  │
│  │                                                          │  │
│  │  ┌─────────────────────────────────────────────────────┐ │  │
│  │  │      Private Route Table (No Internet Route)        │ │  │
│  │  └──────┬──────────────────────────────┬───────────────┘ │  │
│  │         │                              │                │  │
│  │  ┌──────▼──────────────┐       ┌───────▼──────────┐    │  │
│  │  │ Private Subnet 1    │       │ Private Subnet 2 │    │  │
│  │  │ 10.0.3.0/24 (AZ-1a) │       │ 10.0.4.0/24(AZ-1b)   │  │
│  │  │                      │       │                  │    │  │
│  │  │ ┌───────────────────┐│       │                  │    │  │
│  │  │ │ Jenkins Server    ││       │ SonarQube Server │    │  │
│  │  │ │ (t2.large)        ││       │ (t2.micro)       │    │  │
│  │  │ │ NO Public IP      ││       │ NO Public IP     │    │  │
│  │  │ │ Port 8080         ││       │ Port 9000        │    │  │
│  │  │ └───────────────────┘│       │                  │    │  │
│  │  │                      │       │                  │    │  │
│  │  └──────────────────────┘       └──────────────────┘    │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## ⚠️ Important Note on Private Instances

**The Jenkins and SonarQube instances are in PRIVATE subnets WITHOUT internet access (no NAT Gateway). This means they CANNOT download packages from the internet during the bootstrap phase (user-data execution).**

### Two Solutions:

1. **Option 1: Temporary Public Access (Quick Testing)**
   ```
   Move Jenkins and SonarQube to public subnets temporarily
   This allows them to download packages
   Assign Elastic IPs if needed
   Move back to private subnets after setup
   ```

2. **Option 2: Add NAT Gateway (Production Ready)**
   ```
   Later, add a NAT Gateway in one public subnet
   Update the private route table with: 0.0.0.0/0 → NAT Gateway
   This gives private instances internet access for downloads
   Incurs minimal additional costs
   ```

For this initial setup, the user-data scripts are configured but packages will need to be installed via the Bastion host or by temporarily moving instances to public subnets.

## 📁 Project Structure

```
terraform-aws-devsecops-Raju/
├── README.md
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security-groups/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ec2/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── environments/
    ├── dev/
    │   ├── versions.tf
    │   ├── provider.tf
    │   ├── variables.tf
    │   ├── terraform.tfvars
    │   ├── locals.tf
    │   ├── data.tf
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── user-data/
    │       ├── bastion.sh
    │       ├── jenkins.sh
    │       └── sonarqube.sh
    ├── test/
    │   ├── versions.tf
    │   ├── provider.tf
    │   ├── variables.tf
    │   ├── terraform.tfvars
    │   ├── locals.tf
    │   ├── data.tf
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── user-data/
    │       ├── bastion.sh
    │       ├── jenkins.sh
    │       └── sonarqube.sh
    └── prod/
        ├── versions.tf
        ├── provider.tf
        ├── variables.tf
        ├── terraform.tfvars
        ├── locals.tf
        ├── data.tf
        ├── main.tf
        ├── outputs.tf
        └── user-data/
            ├── bastion.sh
            ├── jenkins.sh
            └── sonarqube.sh
```

## 🚀 Quick Start Guide

### Prerequisites

1. Install Terraform >= 1.6.0
   ```bash
   terraform version
   ```

2. Configure AWS credentials
   ```bash
   aws configure
   # Or set environment variables:
   export AWS_ACCESS_KEY_ID=your_key
   export AWS_SECRET_ACCESS_KEY=your_secret
   ```

3. Update your public IP in the environment files
   
   **For DEV environment:**
   ```bash
   your_public_ip = "YOUR_PUBLIC_IP/32"  # Get it from https://checkip.amazonaws.com
   # In: environments/dev/terraform.tfvars
   ```
   
   **For TEST environment:**
   ```bash
   your_public_ip = "YOUR_PUBLIC_IP/32"
   # In: environments/test/terraform.tfvars
   ```
   
   **For PROD environment:**
   ```bash
   your_public_ip = "YOUR_PUBLIC_IP/32"
   # In: environments/prod/terraform.tfvars
   ```

### Deployment Steps

**Deploy DEV Environment:**
```bash
# Navigate to the dev environment
cd environments/dev

# Initialize Terraform (downloads providers and modules)
terraform init

# Format all Terraform files for consistency
terraform fmt -recursive

# Validate the configuration syntax
terraform validate

# Create and show the execution plan
terraform plan

# Apply the configuration to create AWS resources
terraform apply
```

**Deploy TEST Environment:**
```bash
# Navigate to the test environment
cd ../../environments/test

# Initialize Terraform
terraform init

# Format, validate, and plan
terraform fmt -recursive
terraform validate
terraform plan

# Apply the configuration
terraform apply
```

**Deploy PROD Environment:**
```bash
# Navigate to the prod environment
cd ../../environments/prod

# Initialize Terraform
terraform init

# Format, validate, and plan
terraform fmt -recursive
terraform validate
terraform plan

# Apply the configuration (more careful for production)
terraform apply
```

## 🔐 Security Group Rules

### Bastion Security Group
- **Inbound**: SSH (port 22) only from your public IP
- **Outbound**: All traffic to anywhere (for updates and downloads)

### Jenkins Security Group
- **Inbound**:
  - SSH (port 22) only from Bastion Security Group
  - HTTP (port 8080) only from Bastion Security Group
- **Outbound**: All traffic (though won't reach internet without NAT)

### SonarQube Security Group
- **Inbound**:
  - SSH (port 22) only from Bastion Security Group
  - HTTP (port 9000) only from Bastion Security Group
- **Outbound**: All traffic (though won't reach internet without NAT)

## 💻 SSH Connection Guide

### Connect to Bastion Host

```bash
# Get the bastion public IP from Terraform outputs
terraform output bastion_public_ip

# SSH to bastion (replace with your key pair name and actual IP)
ssh -i /path/to/your-key-pair.pem ubuntu@<BASTION_PUBLIC_IP>
```

### Connect to Jenkins from Bastion

```bash
# First, SSH to bastion (as shown above)
# Then from bastion, SSH to Jenkins using private IP
ssh -i /path/to/your-key-pair.pem ubuntu@<JENKINS_PRIVATE_IP>

# Or in one command: SSH tunneling through bastion
ssh -i /path/to/your-key-pair.pem \
    -J ubuntu@<BASTION_PUBLIC_IP> \
    ubuntu@<JENKINS_PRIVATE_IP>

# Access Jenkins web UI through bastion port forwarding
ssh -i /path/to/your-key-pair.pem \
    -L 8080:localhost:8080 \
    -J ubuntu@<BASTION_PUBLIC_IP> \
    ubuntu@<JENKINS_PRIVATE_IP>

# Then open browser to: http://localhost:8080
```

### Connect to SonarQube from Bastion

```bash
# SSH to SonarQube through bastion
ssh -i /path/to/your-key-pair.pem \
    -J ubuntu@<BASTION_PUBLIC_IP> \
    ubuntu@<SONARQUBE_PRIVATE_IP>

# Port forward for SonarQube web UI
ssh -i /path/to/your-key-pair.pem \
    -L 9000:localhost:9000 \
    -J ubuntu@<BASTION_PUBLIC_IP> \
    ubuntu@<SONARQUBE_PRIVATE_IP>

# Then open browser to: http://localhost:9000
```

## 📊 Instance Details

| Server | Instance Type | Subnet Type | Volume Size | Public IP | Purpose |
|--------|---|---|---|---|---|
| Bastion | t2.micro | Public | 20 GB | Yes | Gateway for access |
| Jenkins | t2.large | Private | 25 GB | No | CI/CD Pipeline |
| SonarQube | t2.micro | Private | 12 GB | No | Code Quality Analysis |

## 🌍 Multi-Environment Setup

This project supports three separate environments to manage infrastructure lifecycle:

### **DEV Environment**
- **Location**: `environments/dev/`
- **AWS Region**: us-east-1
- **VPC CIDR**: 10.0.0.0/16
- **Bastion**: t2.micro, 20GB
- **Jenkins**: t2.large, 25GB
- **SonarQube**: t2.micro, 12GB
- **Purpose**: Development and testing
- **Key Name**: Update key pair in `terraform.tfvars`

### **TEST Environment**
- **Location**: `environments/test/`
- **AWS Region**: us-east-1
- **VPC CIDR**: 10.1.0.0/16
- **Bastion**: t2.micro, 20GB
- **Jenkins**: t2.large, 25GB
- **SonarQube**: t2.micro, 12GB
- **Purpose**: User acceptance testing (UAT) and validation
- **Key Name**: Update key pair in `terraform.tfvars`

### **PROD Environment**
- **Location**: `environments/prod/`
- **AWS Region**: us-west-2 (different region for disaster recovery)
- **VPC CIDR**: 10.2.0.0/16
- **Bastion**: t2.small, 30GB (more robust)
- **Jenkins**: t2.xlarge, 50GB (higher capacity)
- **SonarQube**: t2.large, 30GB (better performance)
- **Purpose**: Production workloads
- **Key Name**: Update key pair in `terraform.tfvars` (must exist in us-west-2)

### Environment Management

Each environment is completely isolated with:
- Separate VPC CIDR blocks avoiding conflicts
- Independent state files
- Different instance types and volumes based on workload requirements
- Isolated security groups and subnets

To deploy or manage an environment:
```bash
cd environments/{dev|test|prod}
terraform init
terraform plan
terraform apply
```

## 🔧 Customization

### Change Region
Edit `environments/{dev|test|prod}/terraform.tfvars`:
```hcl
aws_region = "us-east-1"  # Change to desired region
```

### Change Your Public IP
```hcl
your_public_ip = "YOUR_NEW_IP/32"
```

### Change VPC CIDR
```hcl
vpc_cidr = "10.0.0.0/16"  # Modify as needed
```

### Change Instance Types
```hcl
bastion_instance_type    = "t2.micro"
jenkins_instance_type    = "t2.large"
sonarqube_instance_type  = "t2.micro"
```

## 🗑️ Cleanup

To destroy resources in a specific environment:

```bash
# Destroy DEV environment
cd environments/dev
terraform destroy

# Destroy TEST environment
cd ../test
terraform destroy

# Destroy PROD environment
cd ../prod
terraform destroy
```

**Destroy all environments (if needed):**
```bash
# From project root
for env in dev test prod; do
  cd environments/$env
  terraform destroy -auto-approve  # Use with caution!
  cd ../..
done
```

Type `yes` when prompted (or use `-auto-approve` carefully). This will delete:
- All EC2 instances
- Security groups
- Subnets
- VPC
- Internet Gateway
- All other resources in that environment

⚠️ **Warning**: Destruction is irreversible. Ensure all important data is backed up before destroying production infrastructure.

## 📝 Outputs

After successful deployment of each environment, Terraform will output:
- Bastion public IP
- Bastion private IP
- Jenkins private IP
- SonarQube private IP
- VPC ID and CIDR
- Subnet IDs and CIDRs
- Security group IDs
- SSH connection commands (pre-formatted)
- Port forwarding commands

View outputs for a specific environment:
```bash
# For DEV environment
cd environments/dev
terraform output

# For TEST environment
cd ../test
terraform output

# For PROD environment
cd ../prod
terraform output

# Show specific output value
terraform output bastion_public_ip
```

**Useful output commands:**
```bash
# Get all outputs in JSON format
terraform output -json

# Get specific outputs for scripting
terraform output bastion_public_ip -raw
terraform output jenkins_private_ip -raw
```

## 🎓 Learning Points

This project demonstrates:
1. **Modular Terraform**: Reusable modules for VPC, security groups, and EC2
2. **Variables & Locals**: Using variables for customization and locals for common values
3. **Data Sources**: Looking up AMI IDs dynamically
4. **Security Best Practices**: IMDSv2, encrypted volumes, restricted security groups
5. **Multi-AZ Design**: Resilient architecture across availability zones
6. **Cost Optimization**: No unnecessary services like NAT Gateway in dev
7. **Multi-Environment Management**: Separate dev, test, and prod environments with isolated state
8. **Environment Isolation**: Different regions, VPCs, and instance types per environment
9. **Infrastructure as Code**: Version-controlled, reproducible infrastructure
10. **Scalability**: Easy to replicate environments or add new ones

## 📚 References

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS VPC Best Practices](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Introduction.html)
- [Terraform Best Practices](https://www.terraform.io/language/settings/backends/s3)
- [AWS EC2 Instance Types](https://aws.amazon.com/ec2/instance-types/)

## ✅ Requirements Checklist

- ✅ Terraform >= 1.6.0
- ✅ AWS Provider >= 5.0
- ✅ Custom VPC with no default VPC usage
- ✅ 2 Public subnets across 2 AZs
- ✅ 2 Private subnets across 2 AZs
- ✅ Internet Gateway
- ✅ No NAT Gateway (for cost)
- ✅ Bastion in public subnet (t2.micro, 20GB)
- ✅ Jenkins in private subnet (t2.large, 25GB)
- ✅ SonarQube in private subnet (t2.micro, 12GB)
- ✅ Security groups with proper rules
- ✅ User-data scripts for all servers
- ✅ Modular structure (VPC, SG, EC2 modules)
- ✅ IMDSv2 enabled
- ✅ Encrypted gp3 volumes
- ✅ Locals for common tags
- ✅ Ubuntu 22.04 LTS AMI lookup
- ✅ cidrsubnet() for subnet CIDRs
- ✅ Proper route tables and associations

---

**Author**: DevOps Engineer Raju  
**Created**: 2026  
**Terraform Version**: >= 1.6.0  
**AWS Provider Version**: >= 5.0
