resource "aws_s3_bucket" "sueshop_s3_bkt" {
  bucket = var.bucket_name

  force_destroy = false

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "logs" {
  bucket = "${var.bucket_name}-logs"

  force_destroy = false

  tags = {
    Name        = "${var.bucket_name}-logs"
    Environment = var.environment
  }
}