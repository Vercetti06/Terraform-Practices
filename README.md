# Terraform Remote Backend Setup and Environment Configuration

This project demonstrates how to set up and use a remote Terraform backend with AWS S3 for storing Terraform state files and DynamoDB for state locking, enabling safe, collaborative infrastructure automation.

## Project Structure

```
terraform-project/
|-- remote_dir/
| |-- remote.tf # Terraform code to create S3 bucket and DynamoDB table for backend
|-- main_infra_dir/
| |-- main.tf # Main infrastructure code using remote backend
|-- config/
|-- backend-dev.conf # Backend configuration with S3 bucket, key, region, DynamoDB table
|-- dev.tfvars # Environment-specific variables (instance type, environment, allowed IPs)
|-- backend.tf # Backend declaration for Terraform remote state (encrypt = true)
```

## Workflow

### 1. Bootstrap backend infrastructure  
Create S3 bucket and DynamoDB table in `remote_dir` to store state and locking info securely.

### 2. Configure backend settings  
Store S3 bucket name, state file key, region, and DynamoDB table name in `config/backend-dev.conf`.

### 3. Define environment variables  
Use `config/dev.tfvars` to set environment-specific values like EC2 instance type and IP allow list.

### 4. Initialize Terraform with backend  

**Run:**
```
env=dev
terraform get -update=true
terraform init -backend-config=config/backend-${env}.conf
```

### 5. Plan and apply infrastructure  

**Run:**
```
terraform plan -var-file=config/${env}.tfvars
terraform apply -var-file=config/${env}.tfvars
```

## Benefits

- Centralized, encrypted state management with S3 and DynamoDB for state locking.
- Environment-specific configuration supports multiple deployment stages (dev, prod).
- Modular code structure separates backend bootstrap from main infrastructure code.
- Safe concurrent Terraform runs with state locking.

---

This setup follows best practices for managing Terraform state in a multi-environment AWS setup.

