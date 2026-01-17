resource "aws_s3_bucket_lifecycle_configuration" "s3bkt-lfcycle-config" {
  bucket = aws_s3_bucket.sueshop.id

  rule {
    id     = "expire-old-objects"
    status = "Enabled"

    expiration {
      days = 365
    }

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}