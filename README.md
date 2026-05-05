# aws-terraform-petsearch-app
AWS project with Webserver, ALB, Autoscaling, Databases services and SNS 

This repository contains the Terraform configuration to deploy a highly available, scalable WordPress-based application on AWS. The architecture is designed to handle pet search records, image uploads, and automated notifications.

## Architecture Overview

The infrastructure is deployed within a custom VPC across multiple Availability Zones in the `us-west-2` region.

*   **Networking**: A VPC with two public subnets (for the ALB and Bastion) and two private subnets (for Webservers and RDS).
*   **Load Balancing**: An Application Load Balancer (ALB) that distributes traffic to the web tier with session stickiness enabled.
*   **Compute**: An Auto Scaling Group (ASG) that manages a fleet of EC2 instances running Amazon Linux 2023, PHP 8.2, and Apache.
*   **Database**: A Multi-AZ Amazon RDS MySQL instance for persistent data storage.
*   **Storage**: Two S3 buckets for storing pet images and application documents/logs.
*   **Notifications**: SNS topics for Lost Pet alerts, Match Found notifications, and Adoption Requests.

## Key Features

*   **High Availability**: Multi-AZ deployment for both the database and the web tier ensures the application remains available during AZ failures.
*   **Elasticity**: Automatic scaling of the web tier based on CPU utilization (Scale out at 70%, Scale in at 30%).
*   **Security**: 
    *   Webservers and Databases are isolated in private subnets.
    *   Bastion host provides secure SSH access to the environment.
    *   Least-privilege security groups control traffic between tiers.
*   **Automated Bootstrapping**: EC2 instances automatically install and configure WordPress, PHP, and database connections upon launch via `userdata.sh`.
*   **Managed Notifications**: Integrated SNS topics for real-time email alerts on critical application events.

## Prerequisites

### Required Tools
*   **Terraform**: Version 1.0 or higher.
*   **AWS CLI**: Installed and configured with appropriate credentials.
*   **SSH Key Pair**: An existing AWS EC2 Key Pair (default name expected is `vockey`).

### AWS Requirements
*   An active AWS account.
*   Sufficient permissions to create VPCs, EC2 instances, RDS instances, S3 buckets, and SNS topics.

## Getting Started

### 1. Clone the Repository
```bash
git clone <repository-url>
cd aws-terraform-petsearch-app
```

### 2. Configure Variables
Create a `terraform.tfvars` file or provide variables during the plan/apply phase. The following variables are required:

| Variable | Description | Example |
| :--- | :--- | :--- |
| `my_ip` | Your public IP in CIDR format for SSH access | `"203.0.113.1/32"` |
| `db_password` | The master password for the RDS MySQL instance | `"YourSecurePassword123"` |
| `alert_email` | Email address to receive SNS notifications | `"admin@example.com"` |
| `key_name` | (Optional) The name of your SSH key pair | `"my-aws-key"` |

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Review the Plan
```bash
terraform plan
```

### 5. Deploy the Infrastructure
```bash
terraform apply
```
*Confirm the action by typing `yes` when prompted.*

### 6. Access the Application
Once the deployment is complete, Terraform will output the `wordpress_url`. It may take a few minutes for the WordPress installation script to finish and the health checks to pass.

## Outputs

*   **wordpress_url**: The public URL of your PetSearch application.
*   **ssh_bastion_command**: The command to SSH into your environment via the public subnet.
*   **s3_bucket_names**: Names of the created S3 buckets for images and documents.
*   **sns_topic_arns**: ARNs for the lost pet, match found, and adoption request topics.

## Cleanup
To avoid ongoing charges, destroy the infrastructure when it is no longer needed:
```bash
terraform destroy
```
