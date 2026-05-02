# 🚀 Azure Secure 3-Tier Architecture with Terraform

This project demonstrates how to deploy a **secure, scalable 3-tier architecture on Microsoft Azure using Terraform**.

It includes a complete setup with networking, compute, load balancing, and a private database, along with automated application deployment.

---

## 📌 Architecture Overview

The system follows a classic 3-tier design:

* **Presentation Layer**: Public Load Balancer
* **Application Layer**: 2 Windows Virtual Machines running ASP.NET
* **Data Layer**: Azure SQL Database (Private Endpoint)
(Please refer file Diagram.png)
### 🔄 Traffic Flow

Internet → Load Balancer → Web VMs → Private Endpoint → Azure SQL Database

---

## ⚙️ Technologies Used

* **Terraform** (Infrastructure as Code)
* **Microsoft Azure**

  * Virtual Network (VNet)
  * Subnets
  * Network Security Group (NSG)
  * Public Load Balancer
  * Virtual Machines (Windows Server)
  * Azure SQL Database
  * Private Endpoint
  * Private DNS Zone
* **ASP.NET Core**
* **GitHub** (Application source)

---

## 🔐 Security Features

* Database access via **Private Endpoint only**
* **Public access disabled** for Azure SQL
* Network segmentation using **subnets**
* **NSG rules**:

  * Allow inbound HTTP (80)
  * Allow outbound HTTPS (443)
* No direct public access to Virtual Machines

---

## 🚀 Deployment Flow

1. Clone the repository
2. Initialize Terraform
3. Apply infrastructure
4. VM Extension automatically:

   * Installs IIS / .NET
   * Downloads web app from GitHub
   * Deploys application

---

## 📂 Project Structure

```
.
├── modules/
│   ├── network/
│   ├── compute/
│   ├── loadbalancer/
│   └── db/
├── scripts/
│   └── setup-web.ps1
├── webapp/
│   └── publish/
├── main.tf
├── variables.tf
└── README.md
```

---

## 🧪 Application

A simple ASP.NET application that:

* Connects to Azure SQL Database
* Retrieves course data
* Displays it in a web table

Example data:

| Course | Description         |
| ------ | ------------------- |
| AZ-104 | Azure Administrator |
| AZ-305 | Azure Architect     |
| AZ-102 | Azure AI Service    |

---

## 📊 Key Highlights

* Fully automated infrastructure using Terraform
* Secure database connectivity via Private Endpoint
* Load-balanced application across multiple VMs
* Automated deployment using VM Extension
* Clean separation of infrastructure and application

---

## 🧠 What I Learned

* Designing secure Azure network architectures
* Using Terraform modules for scalable IaC
* Deploying applications using VM Extensions
* Troubleshooting networking and connectivity issues
* Integrating application layer with cloud infrastructure

---

## 📎 Future Improvements

* Add CI/CD pipeline (GitHub Actions / Azure DevOps)
* Use Azure Key Vault for secrets management
* Replace IIS deployment with containerized app (AKS / App Service)
* Add monitoring (Azure Monitor, Log Analytics)

---

## 👨‍💻 Author

Bách Berry
Cloud Engineer | Azure | Terraform | DevOps

---

## ⭐ Notes

This project is designed for learning and portfolio purposes and follows best practices for cloud architecture and infrastructure automation.
