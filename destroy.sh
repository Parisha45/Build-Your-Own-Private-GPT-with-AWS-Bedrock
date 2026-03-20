#!/bin/bash

set -e

echo "🗑️  Destroying AWS SAP-C02 Knowledge Base Chat Application"
echo ""

# Step 1: Empty S3 bucket (required before Terraform can destroy it)
echo "🧹 Emptying S3 bucket..."
cd terraform
S3_BUCKET=$(terraform output -raw s3_bucket_name 2>/dev/null || echo "")

if [ -n "$S3_BUCKET" ]; then
    echo "   Removing all objects from $S3_BUCKET..."
    aws s3 rm s3://$S3_BUCKET/ --recursive || echo "   Bucket already empty or doesn't exist"
else
    echo "   No S3 bucket found in Terraform state"
fi

# Step 2: Destroy Terraform resources
echo ""
echo "💥 Destroying infrastructure with Terraform..."
terraform destroy -auto-approve

cd ..

echo ""
echo "✅ All resources destroyed successfully!"
echo ""
echo "⚠️  Note: CloudFront distributions may take 10-15 minutes to fully delete"
