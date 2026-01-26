resource "aws_s3_bucket_policy" "cloudfront_only" {
  bucket = aws_s3_bucket.sueshop_s3_bkt.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "cloudfront.amazonaws.com"
      }
      Action   = "s3:GetObject"
      Resource = "${aws_s3_bucket.sueshop_s3_bkt.arn}/*"
      Condition = {
        StringEquals = {
          "AWS:SourceArn" = aws_cloudfront_distribution.cldfrnt-dist.arn
        }
      }
    }]
  })
}