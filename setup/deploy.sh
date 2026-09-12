#!/bin/bash
set -e

echo "=== 0. Loading AWS Credentials ==="
if [ -d "./terraform" ]; then
  cd terraform
  if [ -f "./fix.sh" ]; then
    source ./fix.sh
  elif [ -f "../fix.sh" ]; then
    source ../fix.sh
  fi
  cd ..
elif [ -f "./fix.sh" ]; then
  source ./fix.sh
fi

echo "=== 1. Updating Kubeconfig ==="
aws eks update-kubeconfig --region us-east-1 --name cluster

echo "=== 2. Setting Cluster Access Permissions ==="
# Temporarily redefine exit and allow non-zero exit code so duplicate IAM entries won't stop execution
exit() { :; }
if [ -f "./init.sh" ]; then
  source ./init.sh || true
elif [ -f "../init.sh" ]; then
  source ../init.sh || true
fi
unset -f exit

echo "=== 3. Authenticating Docker to Private & Public ECR ==="
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION="us-east-1"

# Login to your Private ECR
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Login to AWS Public ECR to bypass rate limits
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws

echo "=== 4. Building & Pushing Frontend Image ==="
if [ -d "frontend" ]; then
  docker build -t frontend ./frontend
  docker tag frontend:latest $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/frontend:latest
  docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/frontend:latest
elif [ -d "../starter/frontend" ]; then
  docker build -t frontend ../starter/frontend
  docker tag frontend:latest $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/frontend:latest
  docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/frontend:latest
fi

echo "=== 5. Building & Pushing Backend Image ==="
if [ -d "backend" ]; then
  docker build -t backend ./backend
  docker tag backend:latest $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/backend:latest
  docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/backend:latest
elif [ -d "../starter/backend" ]; then
  docker build -t backend ../starter/backend
  docker tag backend:latest $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/backend:latest
  docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/backend:latest
fi

echo "=== 6. Deploying Kubernetes Manifests ==="
if [ -d "k8s" ]; then
  kubectl apply -f k8s/
elif [ -d "kubernetes" ]; then
  kubectl apply -f kubernetes/
elif [ -d "../starter/apps" ]; then
  kubectl apply -f ../starter/apps/
fi

echo "=== 7. Deployment Status ==="
kubectl get pods -A
kubectl get svc -A

echo "=== Deployment Completed Successfully ==="