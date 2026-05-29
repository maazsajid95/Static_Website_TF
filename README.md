# Azure Static Website with Terraform & Front Door

A fully infrastructure-as-code deployment of a static website on Azure, provisioned entirely with Terraform.

## Architecture

## Resources Provisioned

- **Resource Group** — logical container for all resources
- **Storage Account** — hosts the static HTML files with Azure's built-in static website feature
- **Azure Front Door Profile** — modern CDN and global load balancer (Standard tier)
- **Front Door Endpoint** — public-facing URL for the site
- **Front Door Origin Group** — load balancing configuration
- **Front Door Origin** — points Front Door to the storage account as the content source
- **Front Door Route** — routes all incoming traffic to the origin, enforces HTTPS

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- An active Azure subscription

## Usage

**1. Clone the repo**
```bash
git clone https://github.com/maazsajid95/Static_Website_TF.git
cd Static_Website_TF
```

**2. Create your tfvars file**
```bash
cp terraform.tfvars.example terraform.tfvars
```
Fill in your values in `terraform.tfvars`.

**3. Authenticate to Azure**
```bash
az login
```

**4. Initialize Terraform**
```bash
terraform init
```

**5. Preview the plan**
```bash
terraform plan
```

**6. Deploy**
```bash
terraform apply
```

**7. Upload your site files**
```bash
az storage blob upload-batch \
  --account-name <mathpracsstorage> \
  --destination '$web' \
  --source . \
  --pattern "*.html" \
  --auth-mode login
```

**8. Tear down**
```bash
terraform destroy
```

## Key Concepts Demonstrated

- Infrastructure as Code with Terraform
- Azure provider configuration and authentication
- Resource dependency graph (implicit references between resources)
- Static website hosting on Azure Blob Storage
- Azure Front Door as a modern CDN replacement for classic Azure CDN
- RBAC data plane vs control plane permissions
- Gitignoring sensitive values with tfvars pattern

## Author

Maaz Sajid — [MathPracs Consulting](https://mathpracs.com)