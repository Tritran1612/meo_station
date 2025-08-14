#!/bin/bash

# EKS Deployment Script for Meo Stationery
# This script deploys your Next.js app to EKS with S3 and RDS integration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Meo Stationery - EKS Deployment Script${NC}"
echo -e "${BLUE}=========================================${NC}"

# Check if terraform state exists
if [ ! -f terraform.tfstate ]; then
    echo -e "${RED}❌ Terraform state not found. Please run 'terraform apply' first.${NC}"
    exit 1
fi

# Get terraform outputs
echo -e "${YELLOW}📊 Getting infrastructure information...${NC}"
EKS_CLUSTER_NAME=$(terraform output -raw eks_cluster_name)
ECR_REPOSITORY_URL=$(terraform output -raw ecr_repository_url)
S3_BUCKET_URL=$(terraform output -raw s3_bucket_url)
RDS_ENDPOINT=$(terraform output -raw rds_endpoint)

echo -e "${GREEN}✅ EKS Cluster: ${EKS_CLUSTER_NAME}${NC}"
echo -e "${GREEN}✅ ECR Repository: ${ECR_REPOSITORY_URL}${NC}"
echo -e "${GREEN}✅ S3 Bucket URL: ${S3_BUCKET_URL}${NC}"
echo -e "${GREEN}✅ RDS Endpoint: ${RDS_ENDPOINT}${NC}"

# Configure kubectl
echo -e "${BLUE}🔧 Configuring kubectl...${NC}"
aws eks update-kubeconfig --region ap-southeast-2 --name "$EKS_CLUSTER_NAME"

# Check EKS cluster status
echo -e "${BLUE}📋 Checking EKS cluster status...${NC}"
kubectl get nodes

# Build and push Docker image
echo -e "${BLUE}🐳 Building and pushing Docker image...${NC}"

# Login to ECR
aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin "$ECR_REPOSITORY_URL"

# Build Docker image
cd ..
docker build -t meo-stationery:latest .

# Tag and push to ECR
docker tag meo-stationery:latest "$ECR_REPOSITORY_URL:latest"
docker tag meo-stationery:latest "$ECR_REPOSITORY_URL:v1.0.0"
docker push "$ECR_REPOSITORY_URL:latest"
docker push "$ECR_REPOSITORY_URL:v1.0.0"

echo -e "${GREEN}✅ Docker image pushed to ECR${NC}"

# Update Kubernetes manifest with actual values
echo -e "${BLUE}🔄 Updating Kubernetes manifest...${NC}"
cd terraform

# Update the deployment file with actual values
sed -i "s|meo-stationery:latest|$ECR_REPOSITORY_URL:latest|g" ../k8s-deployment.yaml
sed -i "s|REPLACE_WITH_S3_URL|$S3_BUCKET_URL|g" ../k8s-deployment.yaml

# Create database URL secret
DATABASE_URL="postgresql://meo_admin:MeoStationery2025_@$RDS_ENDPOINT:5432/postgres"
DATABASE_URL_B64=$(echo -n "$DATABASE_URL" | base64 -w 0)

# Create secret manifest
cat > ../k8s-secret.yaml << EOF
apiVersion: v1
kind: Secret
metadata:
  name: meo-stationery-secrets
  namespace: default
type: Opaque
data:
  database-url: $DATABASE_URL_B64
EOF

# Deploy to Kubernetes
echo -e "${BLUE}☸️ Deploying to Kubernetes...${NC}"
kubectl apply -f ../k8s-secret.yaml
kubectl apply -f ../k8s-deployment.yaml

# Wait for deployment
echo -e "${BLUE}⏳ Waiting for deployment to be ready...${NC}"
kubectl wait --for=condition=available --timeout=300s deployment/meo-stationery-app

# Get service information
echo -e "${BLUE}📍 Getting service information...${NC}"
kubectl get services meo-stationery-service

# Get load balancer URL
echo -e "${YELLOW}⏳ Waiting for Load Balancer to be ready...${NC}"
echo -e "${YELLOW}💡 This may take 2-3 minutes...${NC}"

LB_HOSTNAME=""
while [ -z "$LB_HOSTNAME" ]; do
    echo -e "${YELLOW}⏳ Checking Load Balancer status...${NC}"
    LB_HOSTNAME=$(kubectl get service meo-stationery-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
    if [ -z "$LB_HOSTNAME" ]; then
        sleep 30
    fi
done

echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
echo -e "${GREEN}🌐 Your application is available at: http://$LB_HOSTNAME${NC}"

echo -e "${BLUE}📋 Useful commands:${NC}"
echo -e "   View pods: ${YELLOW}kubectl get pods${NC}"
echo -e "   View logs: ${YELLOW}kubectl logs -f deployment/meo-stationery-app${NC}"
echo -e "   Scale app: ${YELLOW}kubectl scale deployment meo-stationery-app --replicas=3${NC}"
echo -e "   Update app: ${YELLOW}kubectl set image deployment/meo-stationery-app meo-stationery=$ECR_REPOSITORY_URL:v1.0.1${NC}"
