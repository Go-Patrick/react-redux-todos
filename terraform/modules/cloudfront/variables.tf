variable "region" {
  type = string
  default = "ap-southeast-1"
}

variable "s3_name" {
  type = string
  description = "S3 bucket name"
}

variable "s3_domain_name" {
  type = string
  description = "S3 domain name"
}