variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "key_pair" {
  description = "SSH key pair for EC2"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
}
