module "s3_bucket" {
  source  = "./modules"
  s3_name = var.BUCKET_NAME
}