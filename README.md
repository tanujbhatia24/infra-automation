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

## Set up environment variables
Create `.env` files in each service directory:

**backend/user-service/.env:**
```env
PORT=3001
MONGODB_URI=mongodb://mongodb:27017/ecommerce_users
JWT_SECRET=your-jwt-secret-key
```

**backend/product-service/.env:**
```env
PORT=3002
MONGODB_URI=mongodb://mongodb:27017/ecommerce_products
```

**backend/cart-service/.env:**
```env
PORT=3003
MONGODB_URI=mongodb://mongodb:27017/ecommerce_carts
PRODUCT_SERVICE_URL=http://localhost:3002
```

**backend/order-service/.env:**
```env
PORT=3004
MONGODB_URI=mongodb://localhost:27017/ecommerce_orders
CART_SERVICE_URL=http://localhost:3003
PRODUCT_SERVICE_URL=http://localhost:3002
USER_SERVICE_URL=http://localhost:3001
```

**frontend/.env:**
```env
REACT_APP_USER_SERVICE_URL=http://localhost:3001
REACT_APP_PRODUCT_SERVICE_URL=http://localhost:3002
REACT_APP_CART_SERVICE_URL=http://localhost:3003
REACT_APP_ORDER_SERVICE_URL=http://localhost:3004
```
---

## Docker Image Setup

Build and push Docker images for all services:

```bash
# Build (from inside each service folder or use full path)
docker build -t <your-dockerhub>/user-service .\user-service
docker build -t <your-dockerhub>/product-service .\product-service
docker build -t <your-dockerhub>/order-service .\order-service
docker build -t <your-dockerhub>/cart-service .\cart-service
docker build -t <your-dockerhub>/frontend-service .\frontend

# Push
docker push <your-dockerhub>/user-service
docker push <your-dockerhub>/products-service
docker push <your-dockerhub>/orders-service
docker push <your-dockerhub>/cart-service
docker push <your-dockerhub>/frontend-service

# Run to create common network
docker network create ecommerce-net

# Run Mongo in order to test the backend services
docker run -d --name mongodb --network ecommerce-net -p 27017:27017 mongo

#Run
docker run -d --name frontend-service --network ecommerce-net -p 3000:3000 -e MONGO_URL=mongodb://mongodb:27017/ecommerce_carts <your-dockerhub>/frontend-service
docker run -d --name user-service --network ecommerce-net -p 3001:3001 -e MONGO_URL=mongodb://mongodb:27017/ecommerce_carts <your-dockerhub>/user-service
docker run -d --name product-service --network ecommerce-net -p 3002:3002 -e MONGO_URL=mongodb://mongodb:27017/ecommerce_carts <your-dockerhub>/product-service
docker run -d --name cart-service --network ecommerce-net -p 3003:3003 -e MONGODB_URI=mongodb://mongodb:27017/ecommerce_carts <your-dockerhub>/cart-service
docker run -d --name order-service --network ecommerce-net -p 3004:3004 -e MONGO_URL=mongodb://mongodb:27017/ecommerce_carts <your-dockerhub>/order-service
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
- Env variables setup for local run
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

## Snapshot
- dokcer images<br>
<img width="889" height="161" alt="image" src="https://github.com/user-attachments/assets/a2cb8690-3c76-41f8-8403-bedeb84f3691" /><br>
<img width="1377" height="402" alt="image" src="https://github.com/user-attachments/assets/3596600a-b538-405a-9daa-ae63e33a7c35" /><br>
- docker containers<br>
<img width="1561" height="318" alt="image" src="https://github.com/user-attachments/assets/cdbdd41a-8704-4f7e-9200-d5a979f41ed2" /><br>
<img width="1404" height="465" alt="image" src="https://github.com/user-attachments/assets/77f02f14-3cf3-48c6-b944-8c02a4e43cd8" /><br>
- docker frontend local testing<br>
<img width="1855" height="773" alt="image" src="https://github.com/user-attachments/assets/0f2f60c3-dc7a-4d0d-8b68-657196c4ec61" /><br>
- docker backend services<br>
<img width="478" height="229" alt="image" src="https://github.com/user-attachments/assets/deece2c0-f4d4-499f-a5c7-8e887d553619" /><br>
<img width="505" height="227" alt="image" src="https://github.com/user-attachments/assets/5025de0a-4b22-4144-81d9-acfd78ed9284" /><br>
<img width="423" height="228" alt="image" src="https://github.com/user-attachments/assets/b749bd06-aaf5-48f5-a475-8f0bb4479960" /><br>
<img width="412" height="233" alt="image" src="https://github.com/user-attachments/assets/5dbf652c-719f-46a3-b117-e78ccb80cb35" /><br>
- terraform apply output<br>
<img width="959" height="336" alt="image" src="https://github.com/user-attachments/assets/b925567c-6146-4a97-bf9c-b4240395827f" /><br>
<img width="900" height="273" alt="image" src="https://github.com/user-attachments/assets/eb247a62-c54a-45ea-ac58-f6d9b91e6879" /><br>
- AWS EC2 snapshots<br>
<img width="1355" height="661" alt="image" src="https://github.com/user-attachments/assets/4b1fa98a-5f9f-4b07-9803-bdbf9f636a47" /><br>
<img width="326" height="73" alt="image" src="https://github.com/user-attachments/assets/05d9066f-62b8-4186-a2d9-8b2b35b74231" /><br>
<img width="650" height="82" alt="image" src="https://github.com/user-attachments/assets/6e48274a-3f35-40d5-b997-26333e9d58bb" /><br>
- AWS EC2 frontend service<br>
<img width="837" height="335" alt="image" src="https://github.com/user-attachments/assets/a19fc52b-0ccf-4dc7-90d9-480855b44849" /><br>
- AWS EC2 backend services<br>
<img width="447" height="229" alt="image" src="https://github.com/user-attachments/assets/21896c5b-7b7a-4149-80de-336d429bdead" /><br>
<img width="482" height="228" alt="image" src="https://github.com/user-attachments/assets/1e9edace-cd3f-4d70-8131-f6c882b46281" /><br>
<img width="449" height="221" alt="image" src="https://github.com/user-attachments/assets/1f9228aa-3c62-4359-aec9-ff32bd671c65" /><br>
<img width="447" height="241" alt="image" src="https://github.com/user-attachments/assets/d0ae60a7-7aaa-4cdf-950e-02d0903269e5" /><br>
- terraform destroy output<br>
<img width="988" height="384" alt="image" src="https://github.com/user-attachments/assets/b395298a-4bf7-4fe8-b63c-d973247b2182" /><br>
- AWS EC2 snapshots<br>
<img width="1340" height="251" alt="image" src="https://github.com/user-attachments/assets/62073a6d-e846-4b98-ae5e-69f68a9fa4e9" /><br>
---

## Author<br>
Tanuj Bhatia<br>
DevOps Automation Engineer<br>
DockerHub: tanujbhatia24<br>

---
