variable "s3_lambda_bucket" {
  type        = string
  description = "Bucket to hold lambda function code"
  default     = "lamda-bucket-terraform-example-aarti"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "aws_profile" {
  type        = string
  description = "AWS Profile"
  default     = "default"
}
