🚀 Enterprise Full-Stack Microservices CI/CD Pipeline on AWS EKS
----
A production-grade, highly reliable Continuous Integration and Continuous Deployment (CI/CD) system built from scratch using GitHub Actions, Docker, Amazon ECR, and AWS EKS (Elastic Kubernetes Service).
This repository showcases automated build verification, dependency caching, dynamic environment variable injection, zero-downtime rolling updates, and secure cloud orchestration for microservice architectures.

🎯 Project Motive & Objective
---
In modern cloud engineering, delivering code to production requires speed, predictability, and safety. The core motive of this project was to establish a fully automated release engine that completely eliminates manual deployments, prevents broken code from reaching production, and dynamically connects distributed microservices in a cloud-native environment.

Primary Objectives:
---
Automated Quality Gates: Enforce non-blocking code validation (`linting` and `unit testing`) on every Pull Request before any containerization occurs.
Immutable Infrastructure & Containerization: Package frontend and backend services into isolated Docker images and manage container lifecycles using Amazon Elastic Container Registry (ECR).
Automated Deployment to AWS EKS: Automate Kubernetes rolling deployments on every merge to `main`, ensuring zero system downtime.
Dynamic API Configuration: Eliminate hardcoded endpoints by dynamically injecting backend LoadBalancer URLs into frontend builds at compile time via Docker build arguments and secret managers.
Production Security: Safeguard infrastructure credentials through encrypted secret delegation without exposing AWS keys or sensitive URLs in raw repository code.

🏗️ Architecture & Pipeline Overview
---
```
                               ┌─────────────────────────┐
                               │    GitHub Repository    │
                               └────────────┬────────────┘
                                            │
                   ┌────────────────────────┴────────────────────────┐
                   │                                                 │
          [ Pull Request ]                                    [ Push to main ]
                   │                                                 │
                   v                                                 v
        ┌──────────────────────┐                          ┌──────────────────────┐
        │  Frontend/Backend CI │                          │  Frontend/Backend CD │
        │  - Linting           │                          │  - Linting           │
        │  - Unit Testing      │                          │  - Unit Testing      │
        │  - Docker Build Check│                          │  - Docker Build      │
        └──────────────────────┘                          └──────────┬───────────┘
                                                                     │
                                                                     v
                                                          ┌──────────────────────┐
                                                          │   AWS ECR Registry   │
                                                          └──────────┬───────────┘
                                                                     │
                                                                     v
                                                          ┌──────────────────────┐
                                                          │   AWS EKS Cluster    │
                                                          │  (Kubernetes Pods)   │
                                                          └──────────────────────┘
```
---
🛠️ Detailed Execution Strategy
---
The implementation was built through a structured, multi-phase DevOps workflow:
1. Continuous Integration (CI) Workflows (`frontend-ci.yaml` & `backend-ci.yaml`)
Trigger: Activated automatically on any `pull_request` targeting the `main` branch, as well as manual triggers (`workflow_dispatch`).
Parallel Execution: Executed `lint` and `test` jobs in parallel to reduce pipeline runtimes. Dependency caching via Node/Python managers was configured to accelerate setup steps.
Strict Dependencies: The `build` job was configured using `needs: [lint, test]`, ensuring that Docker containerization runs only if all linting rules and test suites pass completely.
2. Continuous Deployment (CD) Workflows (`frontend-cd.yaml` & `backend-cd.yaml`)
Trigger: Triggered upon direct pushes or merged PRs to `main`.
Sequential Verification: Included mandatory in-line linting and unit testing prior to any build step to maintain total pipeline integrity.
ECR Authentication: Integrated `aws-actions/amazon-ecr-login` using encrypted IAM credentials sourced directly from GitHub Secrets.
Rolling Kubernetes Deployment: Built tagged Docker images, pushed them to Amazon ECR, and executed `kubectl set image deployment/...` against the live AWS EKS cluster for zero-downtime rollouts.
3. Dynamic Microservice Binding (`REACT_APP_MOVIE_API_URL`)
To prevent CORS errors and avoid hardcoding public backend URLs into the frontend image, the frontend CD pipeline passes the live backend AWS LoadBalancer URL during image compilation:
```bash
  docker build \
    --build-arg REACT_APP_MOVIE_API_URL="${{ secrets.REACT_APP_MOVIE_API_URL }}" \
    -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
  ```
This ensures the React application is compiled with the exact active backend endpoint without revealing sensitive environment details inside the repository files.

📁 Repository Structure
```text
.
├── .github/
│   └── workflows/
│       ├── frontend-ci.yaml   # CI pipeline for Frontend PRs (Lint, Test, Build)
│       ├── frontend-cd.yaml   # CD pipeline for Frontend EKS Deployment
│       ├── backend-ci.yaml    # CI pipeline for Backend PRs (Lint, Test, Build)
│       └── backend-cd.yaml    # CD pipeline for Backend EKS Deployment
├── frontend/                  # React Frontend source code & Dockerfile
├── backend/                   # Node.js/Express Backend API source code & Dockerfile
└── README.md                  # Project Documentation
```
---
⚙️ Configuration & Environment Setup
---
To run this pipeline in your own cloud environment, configure the following GitHub Secrets under Settings > Secrets and variables > Actions:
Secret Name	Purpose
`AWS_ACCESS_KEY_ID`	AWS IAM credentials with permissions for ECR & EKS
`AWS_SECRET_ACCESS_KEY`	AWS IAM secret key
`AWS_REGION`	AWS target region (e.g., `us-east-1`)
`REACT_APP_MOVIE_API_URL`	The active AWS LoadBalancer URL pointing to the Backend API
Verifying Kubernetes Deployment
To check the running workloads on your EKS cluster:
```bash
# Connect local kubeconfig to the remote EKS cluster
aws eks update-kubeconfig --name <YOUR_CLUSTER_NAME> --region <YOUR_AWS_REGION>

# Verify node status
kubectl get nodes

# Check running services and LoadBalancer external IPs
kubectl get svc -o wide

# Monitor deployment rollout logs
kubectl get pods -w
```
---
