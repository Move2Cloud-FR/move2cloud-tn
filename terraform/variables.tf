variable "AWS_REGION" {
  type        = string
  default     = "eu-west-1"
  description = "AWS region"
}

variable "GITHUB_ORG" {
  type        = string
  default     = "Move2Cloud-FR"
  description = "GitHub organisation or user that owns the repository"
}

variable "GITHUB_REPO" {
  type        = string
  default     = "move2cloud-tn"
  description = "GitHub repository name"
}

variable "S3_BUCKET" {
  type        = string
  default     = "move2cloud.tn"
  description = "S3 bucket name for the static website"
}

variable "CLOUDFRONT_DISTRIBUTION_ARN" {
  type        = string
  default     = ""
  description = "CloudFront distribution ARN for cache invalidation (leave empty if not used)"
}
