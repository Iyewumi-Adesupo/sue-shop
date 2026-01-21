output "bucket_name" {
  value = aws_s3_bucket.sueshop_s3_bkt.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.sueshop_s3_bkt.arn
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.cldfrnt-dist.domain_name
}

output "waf_arn" {
  value = aws_wafv2_web_acl.cloudfront.arn
}

output "waf_log_bucket" {
  value = aws_s3_bucket.waf_logs.bucket
}

output "waf_firehose_name" {
  value = aws_kinesis_firehose_delivery_stream.waf_logs.name
}

output "waf_alerts_topic_arn" {
  value = aws_sns_topic.waf_alerts.arn
}