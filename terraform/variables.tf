variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "private-gpt"
}

variable "knowledge_base_id" {
  description = "AWS Bedrock Knowledge Base ID"
  type        = string
  default     = "GLLIOKE6PZ"  # Replace with your actual Knowledge Base ID
}

variable "bedrock_model_id" {
  description = "Bedrock model ARN to use for generation"
  type        = string
  default     = "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-sonnet-20240229-v1:0"
}
