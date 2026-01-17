resource "aws_sns_topic" "waf_alerts" {
  name = "sueshop-waf-alerts"
}

resource "aws_cloudwatch_metric_alarm" "waf_blocked_requests" {
  alarm_name          = "sueshop-waf-blocked-requests-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 100
  period              = 300
  statistic           = "Sum"

  namespace   = "AWS/WAFV2"
  metric_name = "BlockedRequests"

  dimensions = {
    WebACL = aws_wafv2_web_acl.cloudfront.name
    Region = "Global"
    Rule   = "ALL"
  }

  alarm_description = "High number of blocked requests detected by WAF"
  alarm_actions     = [aws_sns_topic.waf_alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "waf_rate_limit" {
  alarm_name          = "sueshop-waf-rate-limit-triggered"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 10
  period              = 300
  statistic           = "Sum"

  namespace   = "AWS/WAFV2"
  metric_name = "BlockedRequests"

  dimensions = {
    WebACL = aws_wafv2_web_acl.cloudfront.name
    Region = "Global"
    Rule   = "RateLimitRule"
  }

  alarm_description = "WAF rate limiting rule is blocking traffic"
  alarm_actions     = [aws_sns_topic.waf_alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "waf_allowed_spike" {
  alarm_name          = "sueshop-waf-allowed-requests-spike"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 5000
  period              = 300
  statistic           = "Sum"

  namespace   = "AWS/WAFV2"
  metric_name = "AllowedRequests"

  dimensions = {
    WebACL = aws_wafv2_web_acl.cloudfront.name
    Region = "Global"
    Rule   = "ALL"
  }

  alarm_description = "Sudden spike in allowed requests detected"
  alarm_actions     = [aws_sns_topic.waf_alerts.arn]
}