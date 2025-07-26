# Multi-Service Node.js E-commerce Application Deployment with Terraform and Docker

This project demonstrates how to deploy a Dockerized multi-service Node.js application on AWS EC2 using Terraform. It includes 4 backend services (`user`, `products`, `orders`, `cart`) and 1 frontend service.

---

## Services

| Service   | Port   | Description             |
|-----------|--------|-------------------------|
| user      | 3001   | Handles user operations |
| products  | 3002   | Manages product data    |
| orders    | 3004   | Order management        |
| cart      | 3003   | Cart functionality      |
| frontend  | 3000   | Displays homepage       |

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
docker build -t <your-dockerhub>/user-service .\user-service
docker build -t <your-dockerhub>/products-service .\product-service
docker build -t <your-dockerhub>/orders-service .\order-service
docker build -t <your-dockerhub>/cart-service .\cart-service
docker build -t <your-dockerhub>/frontend-service .\frontend

# Push
docker push <your-dockerhub>/user-service
docker push <your-dockerhub>/products-service
docker push <your-dockerhub>/orders-service
docker push <your-dockerhub>/cart-service
docker push <your-dockerhub>/frontend-service

# Run
docker run -d -p 3000:3000 tanujbhatia24/frontend-service
docker run -d -p 3001:3001 tanujbhatia24/user-service
docker run -d -p 3002:3002 tanujbhatia24/product-service
docker run -d -p 3003:3003 tanujbhatia24/cart-service
docker run -d -p 3004:3004 tanujbhatia24/order-service
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

## Snapshot
- dokcer images<br>
<img width="889" height="161" alt="image" src="https://github.com/user-attachments/assets/a2cb8690-3c76-41f8-8403-bedeb84f3691" /><br>
<img width="1377" height="402" alt="image" src="https://github.com/user-attachments/assets/3596600a-b538-405a-9daa-ae63e33a7c35" /><br>
- docker containers<br>
<img width="1509" height="254" alt="image" src="https://github.com/user-attachments/assets/7b0d1eca-17fc-43b1-9dca-dededc205338" /><br>
<img width="1374" height="602" alt="image" src="https://github.com/user-attachments/assets/883a9ada-eac4-4530-b865-ffb5b674391d" /><br>
- docker frontend local testing<br>
<img width="1855" height="773" alt="image" src="https://github.com/user-attachments/assets/0f2f60c3-dc7a-4d0d-8b68-657196c4ec61" /><br>
- docker backend services<br>


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
