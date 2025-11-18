resource "aws_s3_bucket" "media" {
  bucket = var.bucket_name

  tags = {
    Name = "sue-shop-media"
  }
}