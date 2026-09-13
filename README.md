# Movie Catalog Application - EKS Deployment & CI/CD Pipeline

A microservices-based movie catalog application deployed on **AWS Elastic Kubernetes Service (EKS)**, featuring automated **Continuous Integration (CI)** and **Continuous Deployment (CD)** pipelines powered by GitHub Actions.

---

## 🏗️ Architecture & Project Structure

The project is split into two independent services, each containing its own application code, Docker configuration, Kubernetes manifests, and pipeline workflows:

```text
├── starter/
│   ├── backend/             # Node.js/Express backend API
│   │   ├── Dockerfile
│   │   ├── k8s/             # Kubernetes deployment & service manifests
│   │   └── package.json
│   └── frontend/            # Web UI consuming the backend service
│       ├── Dockerfile
│       ├── k8s/             # Kubernetes deployment & service manifests
│       └── package.json
└── .github/
    └── workflows/           # CI/CD pipeline definitions
        ├── backend-ci.yaml
        ├── backend-cd.yaml
        ├── frontend-ci.yaml
        └── frontend-cd.yaml

```

* **Backend Service**: Exposes a RESTful JSON endpoint at `/movies` containing movie records (`id`, `title`).
* **Frontend Service**: A responsive web interface that communicates with the backend service to render the movie list.
* **Infrastructure**: Hosted on AWS EKS (`us-east-1` region) and exposed to external traffic via AWS LoadBalancer (ELB) services.

---

## 🚀 CI/CD Pipeline Automation

The project utilizes four independent GitHub Actions workflows to ensure automated validation and deployment:

1. **Backend Continuous Integration (`backend-ci.yaml`)**: Automatically runs tests and builds the backend artifact.
2. **Backend Continuous Deployment (`backend-cd.yaml`)**: Builds the Docker image, pushes it to the container registry, and applies Kubernetes manifests to the EKS cluster.
3. **Frontend Continuous Integration (`frontend-ci.yaml`)**: Automatically validates and tests frontend code changes.
4. **Frontend Continuous Deployment (`frontend-cd.yaml`)**: Deploys frontend updates directly to the Kubernetes cluster.

---

## 📊 Deployment Verification & Evidence

* **Frontend UI Endpoint**: `[http://aed01985586b4d30a0338deba53000c-2117284287.us-east-1.elb.amazonaws.com](http://aed01985586b4d30a0338deba53000c-2117284287.us-east-1.elb.amazonaws.com)`
* **Backend API Endpoint**: `[http://af42c776ab4db41e29237b98ecdb68ef-1994346062.us-east-1.elb.amazonaws.com/movies](http://af42c776ab4db41e29237b98ecdb68ef-1994346062.us-east-1.elb.amazonaws.com/movies)`
* **Status**: All four GitHub Actions pipelines are fully configured, tested, and verified with passing green builds.

---

## 🛠️ Local Development & Operations

### Prerequisites

* `kubectl` configured with cluster access
* AWS CLI configured with appropriate credentials

### 1. Connect to Cluster

Update your local kubeconfig to target the AWS EKS cluster:

```bash
aws eks update-kubeconfig --name <cluster-name> --region us-east-1

```

### 2. Deploy Services Manually

Apply the Kubernetes configuration files directly:

```bash
kubectl apply -f starter/backend/k8s/
kubectl apply -f starter/frontend/k8s/

```

### 3. Port-Forward for Local Testing

If needed, access services locally via port forwarding:

```bash
# Frontend
kubectl port-forward svc/frontend 3000:80

# Backend
kubectl port-forward svc/backend 5000:80

```
