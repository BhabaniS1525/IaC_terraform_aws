# CSM Terraform — vProfile Infrastructure 🚀

This repository contains Terraform configuration and deployment documentation for the vProfile application infrastructure and supporting services on AWS. The project focuses on centralized Terraform state management (S3 backend), a secured VPC, backend services (RDS, ElastiCache, Amazon MQ), and a frontend running on Elastic Beanstalk.

## Quick summary 🔎

- **Purpose** 🎯: Provide reproducible, versioned infrastructure for the vProfile Java application.
- **Cloud** ☁️: AWS (Terraform-managed).
- **Java app source** 🧩: `vprofile/`
- **Terraform configs** 🛠️: `terraform/`
- **Documentation & runbook** 📚: `Deployment/`

## Repo layout 📁

(high-level):

```
.
├─ Deployment/ 📚
│  ├─ 00_introduction.md
│  ├─ 01_terraform_setup.md
│  ├─ 02_s3_for_backend.md
│  ├─ 03_proivders_and_variables.md
│  ├─ 04_key_pairs.md
│  ├─ 05_vpc_setup.md
│  ├─ 06_security_group_setup.md
│  ├─ 07_backend_setup.md
│  ├─ 08_beanstalk_setup.md
│  └─ 09_bastion_and_db_init.md
├─ terraform/ ⚙️
│  ├─ backend-services.tf
│  ├─ backend.tf
│  ├─ bastion-host.tf
│  ├─ bean-app.tf
│  ├─ bean-env.tf
│  ├─ keypairs.tf
│  ├─ outputs.tf
│  ├─ providers.tf
│  ├─ secgrp.tf
│  ├─ vars.tf
│  └─ templates/
│     └─ db-deploy.tmpl
├─ vprofile/ 🧩
│  ├─ pom.xml
│  ├─ src/
│  └─ target/
└─ Resources/ 🔒
	├─ Credentials/
	└─ Images/

```

Short listing:

- `Deployment/` — runbooks, design notes, and step-by-step guides.

- `terraform/` — all Terraform HCL configs and templates (networking, Beanstalk, backend services).

- `vprofile/` — Java web app (Maven project) and build artifacts.

- `Resources/` — images and example credentials (do not store secrets here in production).

## Prerequisites ✅

- **Terraform** installed (see `Deployment/01_terraform_setup.md`) 🔧.
- **AWS account** with programmatic credentials configured (`aws configure`) 🔑.
- **S3 bucket & DynamoDB** for Terraform remote state (see `Deployment/02_s3_for_backend.md`) 🗄️.
- **Java 17+ & Maven** to build the `vprofile` application (for Beanstalk artifact) ☕️.

## Quick start (local) 🚀

1. Configure AWS credentials:

```bash
aws configure
```

2. Inspect variables in `terraform/vars.tf` and adjust as needed 📝.

3. Initialize and apply Terraform (from repository root):

```bash
cd terraform
terraform init
terraform fmt
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

Notes ⚠️:

- The Beanstalk application and environment are defined in `bean-app.tf` and `bean-env.tf`. The Beanstalk solution stack name must be current (see `Deployment/08_beanstalk_setup.md`).
- Backend services (RDS, ElastiCache, Amazon MQ) are defined in `backend-services.tf` and are deployed into private subnets (see `Deployment/07_backend_setup.md`).
- Keypair files `vprofilekey` / `vprofilekey.pub` exist at the repo root and are referenced by Terraform variables — **do not publish private keys** 🔐.

## Building the Java app 🛠️

From `vprofile/`:

```bash
mvn clean package
# The generated WAR will be in vprofile/target/ and can be used for Beanstalk deployments
```

## Security & housekeeping 🔐🧹

- **Never commit** AWS secrets or environment-specific secrets to the repo. Use environment variables or secret stores for CI.
- **Rotate or delete** IAM users and access keys created for labs when finished.

## Where to look next 🔭

- Read the design and runbooks in `Deployment/` for detailed setup and troubleshooting.
- Terraform configs are in `terraform/` — start with `providers.tf`, `backend.tf`, and `vars.tf`.
