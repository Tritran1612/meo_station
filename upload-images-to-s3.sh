#!/bin/bash

# Upload Product Images to S3 Script
# This script uploads all product images from public/products/ to AWS S3

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Meo Stationery - S3 Image Upload Script${NC}"
echo -e "${BLUE}===========================================${NC}"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo -e "${RED}❌ AWS CLI is not installed. Please install it first:${NC}"
    echo "   curl \"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip\" -o \"awscliv2.zip\""
    echo "   unzip awscliv2.zip"
    echo "   sudo ./aws/install"
    exit 1
fi

# Check if terraform output exists
if [ ! -f terraform.tfstate ]; then
    echo -e "${RED}❌ Terraform state not found. Please run 'terraform apply' first.${NC}"
    exit 1
fi

# Get S3 bucket name from terraform output
S3_BUCKET=$(terraform output -raw s3_bucket_name 2>/dev/null || echo "")

if [ -z "$S3_BUCKET" ]; then
    echo -e "${RED}❌ S3 bucket not found in terraform output. Make sure infrastructure is deployed.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Found S3 bucket: ${S3_BUCKET}${NC}"

# Check if public/products directory exists
if [ ! -d "../public/products" ]; then
    echo -e "${RED}❌ public/products directory not found${NC}"
    exit 1
fi

# Count total images
TOTAL_IMAGES=$(find ../public/products -name "*.jpg" | wc -l)
echo -e "${YELLOW}📊 Found ${TOTAL_IMAGES} images to upload${NC}"

# Upload images with progress
echo -e "${BLUE}🔄 Starting upload...${NC}"

UPLOADED=0

# Loop through each product folder (A, B, C, etc.)
for PRODUCT_DIR in ../public/products/*/; do
    if [ -d "$PRODUCT_DIR" ]; then
        PRODUCT_NAME=$(basename "$PRODUCT_DIR")
        echo -e "${YELLOW}📁 Processing product: ${PRODUCT_NAME}${NC}"
        
        # Upload all images in this product folder
        for IMAGE_FILE in "$PRODUCT_DIR"*.jpg; do
            if [ -f "$IMAGE_FILE" ]; then
                IMAGE_NAME=$(basename "$IMAGE_FILE")
                S3_KEY="products/${PRODUCT_NAME}/${IMAGE_NAME}"
                
                # Upload to S3 with public-read ACL
                aws s3 cp "$IMAGE_FILE" "s3://${S3_BUCKET}/${S3_KEY}" \
                    --acl public-read \
                    --content-type "image/jpeg" \
                    --metadata "product=${PRODUCT_NAME}" \
                    --quiet
                
                UPLOADED=$((UPLOADED + 1))
                echo -e "  ${GREEN}✅ Uploaded: ${IMAGE_NAME} (${UPLOADED}/${TOTAL_IMAGES})${NC}"
            fi
        done
    fi
done

echo -e "${GREEN}🎉 Upload completed! ${UPLOADED}/${TOTAL_IMAGES} images uploaded successfully${NC}"

# Get S3 bucket URL
S3_BASE_URL=$(terraform output -raw s3_bucket_url)
echo -e "${BLUE}📍 Your images are now available at: ${S3_BASE_URL}/products/[PRODUCT]/[IMAGE]${NC}"

# Examples
echo -e "${YELLOW}💡 Example URLs:${NC}"
echo -e "   ${S3_BASE_URL}/products/A/0.jpg"
echo -e "   ${S3_BASE_URL}/products/B/1.jpg"
echo -e "   ${S3_BASE_URL}/products/C/2.jpg"

echo -e "${BLUE}🔧 Next steps:${NC}"
echo -e "   1. Update your Next.js app to use S3 URLs instead of local /products/ paths"
echo -e "   2. Set environment variable: S3_BUCKET_URL=${S3_BASE_URL}"
echo -e "   3. Test image loading in your application"
