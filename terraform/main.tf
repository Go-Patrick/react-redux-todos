module "s3_bucket" {
  source = "./modules/s3"
  s3_name = var.s3_name
}

module "cloudfront" {
  source = "./modules/cloudfront"
  s3_name = var.s3_name
  s3_domain_name = module.s3_bucket.bucket.bucket_regional_domain_name
}