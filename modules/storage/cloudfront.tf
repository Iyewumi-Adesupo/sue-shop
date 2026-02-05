resource "aws_cloudfront_origin_access_control" "cldfnt-access" {
  name                              = "sueshop-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cldfrnt-dist" {
  enabled = true

  web_acl_id = aws_wafv2_web_acl.cloudfront.arn

  origin {
    domain_name              = aws_s3_bucket.sueshop_s3_bkt.bucket_regional_domain_name
    origin_id                = "sueshop-s3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.cldfnt-access.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "sueshop-s3-origin"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name        = "sueshop-cloudfront"
    Environment = var.environment
  }
}