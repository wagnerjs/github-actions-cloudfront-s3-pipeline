variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)

  default = {
    Environment = "Production"
    Project     = "GitHub Actions CloudFront S3 Pipeline"
  }
}

variable "assume_role" {
  type = object({
    role_arn    = string
    external_id = string
  })

  description = "Role ARN and external ID for assuming a role in AWS"

  default = {
    role_arn    = "arn:aws:iam::887155144097:role/TerraformAssumeRole"
    external_id = "54d1ceee-a701-4eb9-9fcf-6b9ce37078ff"
  }
}

variable "bucket_name" {
  type = string

  description = "The name of the S3 bucket to create"

  default = "github-actions-cloudfront-s3-pipeline"
}

variable "cloudfront" {
  type = object({
    enabled                = bool
    default_root_object    = string
    allowed_methods        = list(string)
    cached_methods         = list(string)
    viewer_protocol_policy = string
    name                   = string
  })

  default = {
    enabled                = true
    default_root_object    = "index.html"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "allow-all"
    name                   = "github-actions-cloudfront-s3-pipeline"
  }
}

variable "github_assume_role" {
  type = object({
    name = string
    repo = string
  })

  default = {
    name = "GitHubActionsPipeline"
    repo = "wagnerjs/github-actions-cloudfront-s3-pipeline"
  }
}

variable "github_assume_role_policy" {
  type = object({
    name = string
  })

  default = {
    name = "CloudfrontS3Policy"
  }
}
