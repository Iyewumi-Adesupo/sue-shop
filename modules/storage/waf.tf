resource "aws_wafv2_web_acl" "cloudfront" {
  provider = aws.us_east_1
  scope    = "CLOUDFRONT"

  name = "sueshop-cloudfront-waf"

  default_action {
    allow {}
  }

  rule {
    name     = "RateLimitRule"
    priority = 0

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 1000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimit"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "sueshop-waf"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "waf-webacl-log-config" {
  provider = aws.us_east_1

  resource_arn = aws_wafv2_web_acl.cloudfront.arn
  log_destination_configs = [
    aws_kinesis_firehose_delivery_stream.waf_logs.arn
  ]
}