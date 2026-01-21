resource "aws_s3_bucket_lifecycle_configuration" "s3bkt-lfcycle-config" {
  bucket = aws_s3_bucket.sueshop_s3_bkt.id

  rule {
    id     = "log-retention"
    status = "Enabled"

    expiration {
      days = 365
    }

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}