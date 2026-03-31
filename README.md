# 📘 Active Directory Migration Lab using Terraform (Azure)

## 🚀 Overview
This project demonstrates how to automate Active Directory (AD) infrastructure setup on Azure using Terraform and simulate a domain migration scenario between:

- **Source Domain:** `source.local`
- **Target Domain:** `target.local`

The setup provisions two Windows Server VMs, configures networking, installs AD DS automatically, and prepares the environment for migration tools like ADMT.

---

## 🧱 Architecture

- Azure Resource Group
- Virtual Network & Subnet
- Network Security Group (RDP enabled)
- 2 Windows Server 2022 Virtual Machines:
  - Source Domain Controller (DC)
  - Target Domain Controller (DC)
- Static Private IP configuration
- Public IP for remote access (RDP)
- Automated AD DS installation via VM extensions

---

## 🛠️ Tech Stack

- Terraform (Infrastructure as Code)
- Microsoft Azure
- Windows Server 2022
- Active Directory Domain Services (AD DS)
- PowerShell (Custom Script Extension)

---

## 📂 Project Structure

```text
ad-migration/
│
├── network.tf              # VNet, Subnet, NSG, NIC
├── vm1.tf                  # Source AD VM + AD installation
├── vm2.tf                  # Target AD VM + AD installation
├── provider.tf             # Azure provider config
├── variables.tf            # Input variables
├── terraform.tfvars        # Variable values
├── output.tf               # Outputs (IPs)
│
└── scripts/
    ├── install-ad.ps1          # Source domain setup
    └── install-ad-target.ps1   # Target domain setup
```
---

## ⚙️ What This Project Does

✅ Infrastructure Provisioning
Creates Azure resources using Terraform
Configures networking with static IPs
Enables RDP access via NSG
✅ Active Directory Setup
Installs AD DS role automatically
Promotes both VMs to Domain Controllers:
source.local
target.local
✅ DNS Configuration

Source VM uses:

10.0.1.4, 10.0.1.5

Target VM uses Source DC as DNS:

10.0.1.4

---

## 🧪 Use Case

This lab is useful for:

Active Directory migration practice
Learning ADMT (Active Directory Migration Tool)
Hybrid identity concepts
Real-world enterprise migration simulation

---

## ▶️ How to Run

1. Initialize Terraform
```bash
terraform init
```
2. Validate Config
```bash
terraform validate
```
4. Plan Deployment
```bash
terraform plan
```
6. Apply Infrastructure
```bash
terraform apply -auto-approve
```
---

## 🔐 Accessing the VMs

After deployment:
```bash
terraform output
```
Use the output Public IPs to connect via RDP:

Username: azureuser
Password: Defined in terraform.tfvars

---

## ⚠️ Security Note
RDP is open to all (0.0.0.0/0) for learning purposes

👉 In production:

Restrict access using your IP
Use Azure Bastion or VPN

---

## 🙌 Author

Aakash Deep
DevOps | Cloud & Infrastructure Engineer

🔗 LinkedIn: https://www.linkedin.com/in/aakash-deep-v16/
