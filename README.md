# Multi-Service Node.js E-commerce Application Deployment with Terraform and Docker

This project demonstrates how to deploy a Dockerized multi-service Node.js application on AWS EC2 using Terraform. It includes 4 backend services (`user`, `products`, `orders`, `cart`) and 1 frontend service.

---

## Services

| Service   | Port   | Description             |
|-----------|--------|-------------------------|
| user      | 3001   | Handles user operations |
| products  | 3002   | Manages product data    |
| orders    | 3003   | Order management        |
| cart      | 3004   | Cart functionality      |
| frontend  | 80     | Displays homepage       |

---

## Prerequisites

- Docker installed locally
- AWS CLI configured (`aws configure`)
- Terraform installed (`>= v1.0`)
- DockerHub account (public images or use login)
- AWS access to create EC2, VPC, etc.

---

## Docker Image Setup

Build and push Docker images for all services:

```bash
# Build (from inside each service folder or use full path)
docker build -t <your-dockerhub>/user-service ./user
docker build -t <your-dockerhub>/products-service ./products
docker build -t <your-dockerhub>/orders-service ./orders
docker build -t <your-dockerhub>/cart-service ./cart
docker build -t <your-dockerhub>/frontend-service ./frontend

# Push
docker push <your-dockerhub>/user-service
docker push <your-dockerhub>/products-service
docker push <your-dockerhub>/orders-service
docker push <your-dockerhub>/cart-service
docker push <your-dockerhub>/frontend-service
```
---

## Infrastructure Setup with Terraform

### Files Structure
```bash
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
```

### main.tf Highlights
- Provisions:
  - VPC + Public Subnet
  - Internet Gateway
  - EC2 Instance (Ubuntu)
  - Security Group (port 80, 3001–3004)
- EC2 User Data:
  - Installs Docker
  - Pulls all images
  - Runs containers on specified ports

---
### Run Terraform
```bash
cd terraform
terraform init
terraform apply -auto-approve
```

---
## Access Application
- After deployment, Terraform will output:
  ```bash
  frontend_url = http://<PUBLIC_IP>
  ```
- You can access:
  - Frontend:
    - http://<PUBLIC_IP>
    
  - Backend Services:
    - http://<PUBLIC_IP>:3001 → User
    - http://<PUBLIC_IP>:3002 → Products
    - http://<PUBLIC_IP>:3004 → Orders
    - http://<PUBLIC_IP>:3003 → Cart

- Each backend returns: "ServiceName Service Running"

---

## Validation Checklist
- Docker images built and pushed
- EC2 instance running Docker
- Containers launched via user-data
- Frontend reachable via public IP
- Backend services return expected text

---
## Clean Up
```bash
terraform destroy -auto-approve
```
- Always destroy resources after testing to avoid charges.

---

## Author
Tanuj Bhatia
DevOps Automation Engineer
DockerHub: tanujbhatia24

---
