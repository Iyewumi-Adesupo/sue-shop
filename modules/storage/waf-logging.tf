resource "aws_s3_bucket" "waf_logs" {
  provider = aws.us_east_1
  bucket   = "${var.bucket_name}-waf-logs"

  force_destroy = false

  tags = {
    Name        = "${var.bucket_name}-waf-logs"
    Environment = var.environment
  }
}

resource "aws_iam_role" "firehose_role" {
  provider = aws.us_east_1
  name     = "sueshop-waf-firehose-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = [
          "firehose.amazonaws.com",
          "waf.amazonaws.com"
        ]
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "firehose_policy" {
  provider = aws.us_east_1
  role     = aws_iam_role.firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.waf_logs.arn,
          "${aws_s3_bucket.waf_logs.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_kinesis_firehose_delivery_stream" "waf_logs" {
  name        = "aws-waf-logs-sueshop"
  destination = "extended_s3"
  provider    = aws.us_east_1

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.waf_logs.arn

    prefix = "waf-logs/"

    buffering_size     = 5
    buffering_interval = 300

    compression_format = "GZIP"
  }
}
