#!/bin/bash

set -e

echo "🚀 Deploying AWS SAP-C02 Knowledge Base Chat Application"
echo ""

# Step 1: Package Lambda function
echo "📦 Packaging Lambda function..."
cd lambda
pip install -r requirements.txt -t .
zip -r ../terraform/lambda_function.zip . -x "*.pyc" -x "__pycache__/*"
cd ..

# Step 2: Initialize and apply Terraform
echo ""
echo "🏗️  Deploying infrastructure with Terraform..."
cd terraform
terraform init
terraform plan
terraform apply -auto-approve

# Step 3: Get API endpoint and update frontend
echo ""
echo "🔧 Configuring frontend with API endpoint..."
API_URL=$(terraform output -raw api_url)
cd ..

# Update app.js with the actual API endpoint
sed -i.bak "s|const API_ENDPOINT = '.*';|const API_ENDPOINT = '$API_URL';|" frontend/app.js  #connects ui to backend api
rm -f frontend/app.js.bak

# Upload frontend to S3
echo ""
echo "📤 Uploading frontend to S3..."
cd terraform
S3_BUCKET=$(terraform output -raw s3_bucket_name)
cd ..
aws s3 sync frontend/ s3://$S3_BUCKET/ --exclude "*.bak"

# Get CloudFront URL
cd terraform
CLOUDFRONT_URL=$(terraform output -raw cloudfront_url)
cd ..

echo ""
echo "✅ Deployment complete!"
echo ""
echo "🌐 Your application is live at:"
echo "   $CLOUDFRONT_URL"
echo ""
echo "📍 API Endpoint: $API_URL"
echo ""
echo "⚠️  Note: CloudFront distribution may take 10-15 minutes to fully propagate globally"
