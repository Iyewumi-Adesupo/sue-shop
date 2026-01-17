resource "aws_s3_bucket_logging" "sueshop-s3bkt-logging" {
  bucket = aws_s3_bucket.sueshop.id

  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "access-logs/"
}