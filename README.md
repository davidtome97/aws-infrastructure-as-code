# AWS Infrastructure as Code with Terraform

Infrastructure as Code project built with Terraform to provision a complete AWS environment from scratch.

## Architecture

The project creates:

- Amazon VPC
- Public Subnet
- Internet Gateway
- Route Table
- Security Group
- EC2 Instance

Everything is deployed automatically using Terraform.

---

## Technologies

- Terraform
- AWS EC2
- AWS VPC
- AWS Networking
- Infrastructure as Code (IaC)

---

## Project Structure

```
terraform/

provider.tf

versions.tf

variables.tf

terraform.tfvars

main.tf

outputs.tf
```

---

## Resources Created

| Resource | Status |
|----------|--------|
| VPC | ✅ |
| Public Subnet | ✅ |
| Internet Gateway | ✅ |
| Route Table | ✅ |
| Route Association | ✅ |
| Security Group | ✅ |
| EC2 Instance | ✅ |

---

## Deployment

Initialize Terraform

```bash
terraform init
```

Validate configuration

```bash
terraform validate
```

Review execution plan

```bash
terraform plan
```

Deploy infrastructure

```bash
terraform apply
```

Destroy infrastructure

```bash
terraform destroy
```

---

## Outputs

Terraform returns:

- VPC ID
- Public Subnet ID
- Security Group ID
- EC2 Public IP
- EC2 Public DNS

---

## AWS Console

Infrastructure created successfully.

- VPC
- Public Subnet
- Internet Gateway
- Route Table
- Security Group
- EC2 Instance

---

## Author

David Tomé Arnaiz

Cloud & DevOps Engineer

AWS Certified Solutions Architect – Associate

AWS Certified Cloud Practitioner