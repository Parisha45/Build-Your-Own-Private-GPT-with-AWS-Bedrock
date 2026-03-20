# Build Your Own Private GPT with AWS Bedrock

A serverless AI chat application that allows users to interact with an AWS Bedrock Knowledge Base. This example demonstrates how to build a private GPT-style chatbot for the AWS Certified Solutions Architect - Professional (SAP-C02) exam preparation, but can be adapted for any knowledge base content.

[![AWS](https://img.shields.io/badge/AWS-Bedrock-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/bedrock/)
[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Python](https://img.shields.io/badge/Python-3.11-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

> 🚀 Build your own AI-powered chatbot with AWS Bedrock, Lambda, and CloudFront in minutes!

## 🏗️ Architecture

### Part - 1
<img width="1920" height="1080" alt="Build Your Own Private GPT with AWS Bedrock - 1" src="https://github.com/user-attachments/assets/2e5aa8ef-07b4-4473-829b-2e343833e834" />


### Part - 2
<img width="1920" height="1080" alt="Build Your Own Private GPT with AWS Bedrock - 2" src="https://github.com/user-attachments/assets/bdcaaf3a-6247-4d13-8e4d-02112ad30c0a" />


**Components:**
- **Frontend**: HTML/CSS/JavaScript chat interface hosted on S3 + CloudFront
- **API Gateway**: HTTP API with CORS enabled
- **Lambda Function**: Python 3.11 function to query Bedrock Knowledge Base
- **Bedrock Knowledge Base**: Your custom knowledge base with uploaded documents
- **Infrastructure**: Fully managed with Terraform (IaC)

## 📋 Prerequisites

Before you begin, ensure you have:

- **AWS Account** with appropriate permissions
- **AWS CLI** configured with credentials
- **Terraform** >= 1.0 installed
- **Python** 3.10+ installed
- **AWS Bedrock Knowledge Base** created with your documents
- **IAM Permissions** for:
  - Lambda
  - API Gateway
  - S3
  - CloudFront
  - Bedrock (Retrieve and RetrieveAndGenerate)
  - IAM role creation

### Setting Up Your Knowledge Base

1. Go to AWS Bedrock Console
2. Create a Knowledge Base
3. Upload your documents (PDFs, text files, etc.)
4. Note your Knowledge Base ID
5. Update `terraform/variables.tf` with your Knowledge Base ID

## Project Structure

```
.
├── terraform/
│   ├── main.tf           # Main infrastructure configuration
│   ├── variables.tf      # Terraform variables
│   └── outputs.tf        # Output values
├── lambda/
│   ├── index.py          # Lambda function code
│   └── requirements.txt  # Python dependencies
├── frontend/
│   ├── index.html        # Chat interface
│   ├── styles.css        # Styling
│   └── app.js           # Frontend logic
├── deploy.sh            # Deployment script
└── README.md
```

## Deployment

### Option 1: Automated Deployment

```bash
chmod +x deploy.sh
./deploy.sh
```

### Option 2: Manual Deployment

1. **Package Lambda function:**
```bash
cd lambda
pip install -r requirements.txt -t .
zip -r ../terraform/lambda_function.zip .
cd ..
```

2. **Deploy infrastructure:**
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

3. **Get API endpoint:**
```bash
terraform output api_url
```

4. **Update frontend:**
Edit `frontend/app.js` and replace `YOUR_API_ENDPOINT_HERE` with the API URL from step 3.

## Configuration

### Terraform Variables

You can customize the deployment by modifying `terraform/variables.tf` or creating a `terraform.tfvars` file:

```hcl
aws_region        = "us-east-1"
project_name      = "my-private-gpt"
knowledge_base_id = "YOUR_KNOWLEDGE_BASE_ID"  # Replace with your KB ID
bedrock_model_id  = "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-sonnet-20240229-v1:0"
```

**Important**: Update the `knowledge_base_id` with your actual Bedrock Knowledge Base ID!

### Lambda Environment Variables

The Lambda function uses the following environment variables:
- `KNOWLEDGE_BASE_ID`: Your Bedrock Knowledge Base ID
- `BEDROCK_MODEL_ARN`: The Bedrock model to use for generation (default: Claude 3 Sonnet)

### Customizing System Instructions

The Lambda function includes system instructions that guide the AI's behavior. You can customize these by editing the `system_instruction` variable in `lambda/index.py` to match your use case:

```python
system_instruction = """You are an expert assistant for [YOUR DOMAIN].
Your role is to:
1. Provide accurate information based on the knowledge base
2. [Add your specific requirements]
3. [Customize behavior as needed]
"""
```

## Usage

1. Open `frontend/index.html` in your web browser
2. Type your question about the SAP-C02 exam
3. Click "Send" or press Enter
4. View the AI-generated response with citations

### Example Questions (SAP-C02 Use Case)

- "What are the key domains covered in the SAP-C02 exam?"
- "What is the passing score for the AWS Solutions Architect Professional exam?"
- "What topics are covered in the Design for Organizational Complexity domain?"

**Note**: Customize these examples based on your knowledge base content!

## API Endpoint

### POST /query

**Request:**
```json
{
  "query": "What are the exam domains?"
}
```

**Response:**
```json
{
  "answer": "The exam covers four domains...",
  "citations": [
    {
      "content": "Reference text...",
      "location": {}
    }
  ]
}
```

## Cleanup

To destroy all created resources:

```bash
cd terraform
terraform destroy
```

## 🐛 Troubleshooting

### Lambda Timeout
If queries take too long, increase the timeout in `terraform/main.tf`:
```hcl
timeout = 60  # Increase from 30 to 60 seconds
```

### CORS Issues
The API Gateway is configured to allow all origins (`*`). For production, update the CORS configuration in `terraform/main.tf` to restrict to your domain:
```hcl
allow_origins = ["https://yourdomain.com"]
```

### Bedrock Access
Ensure your AWS account has:
- Access to AWS Bedrock service
- Permissions for your Knowledge Base ID
- Model access enabled for Claude 3 Sonnet

### Frontend Not Loading
If opening `index.html` directly causes CORS errors, use the local server:
```bash
cd frontend
python3 -m http.server 8000
```
Then open http://localhost:8000

Or deploy to S3 + CloudFront (included in Terraform)

## 🔒 Security Considerations

For production deployments, consider:

- ✅ **CORS**: Restrict to specific domains instead of `*`
- ✅ **Authentication**: Implement AWS Cognito or API keys
- ✅ **WAF**: Use AWS WAF to protect API Gateway
- ✅ **Logging**: Enable CloudWatch logs for monitoring
- ✅ **Encryption**: Enable S3 bucket encryption
- ✅ **IAM**: Follow principle of least privilege
- ✅ **Rate Limiting**: Implement API throttling
- ✅ **Secrets**: Use AWS Secrets Manager for sensitive data

## 💰 Cost Estimation

**Estimated Monthly Cost: $1-5** (with moderate usage)

| Service | Cost | Free Tier |
|---------|------|-----------|
| S3 Storage | ~$0.02 | 5GB |
| CloudFront | ~$0.10 | 1TB data transfer |
| API Gateway | ~$1.00 | 1M requests |
| Lambda | ~$0.20 | 1M requests, 400K GB-seconds |
| Bedrock | Variable | ~$0.003 per 1K tokens |
| CloudWatch Logs | ~$0.50 | 5GB ingestion |

**Total**: ~$1-5/month depending on usage

💡 **Tip**: Most costs come from Bedrock token usage. Monitor your usage in AWS Cost Explorer.

## 📄 License
## 📌 Acknowledgement

This project is based on the original work by **Yeshwanth Lakkireddy**.

🔗 Original Repository:
https://github.com/yeshwanthlm/Build-Your-Own-Private-GPT-with-AWS-Bedrock

This version has been modified and used for learning and academic purposes by **Parisha Mahajan**.

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


