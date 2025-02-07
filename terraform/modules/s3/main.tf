resource "aws_s3_bucket" "app_bucket" {
  bucket = var.s3_name
}

resource "aws_s3_bucket_acl" "app_bucket_acl" {
  bucket = aws_s3_bucket.app_bucket.id
  acl = "public-read"
  depends_on = [aws_s3_bucket_ownership_controls.app_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "app_bucket_acl_ownership" {
  bucket = aws_s3_bucket.app_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.app_public_access_lock_config]
}

resource "aws_s3_bucket_public_access_block" "app_public_access_lock_config" {
  bucket = aws_s3_bucket.app_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "app_web_bucket_config" {
  bucket = aws_s3_bucket.app_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.app_bucket.id

  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
          Sid: "PublicReadGetObject",
          Effect: "Allow",
          Principal: "*",
          Action: [
              "s3:GetObject"
          ],
          Resource: [
            "arn:aws:s3:::${var.s3_name}/*",
            "arn:aws:s3:::${var.s3_name}"
          ]
        }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.app_public_access_lock_config]
}