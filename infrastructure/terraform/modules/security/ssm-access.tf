resource "aws_iam_policy" "restricted_ssm_access" {
  name = "sueshop-restricted-ssm-access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:StartSession",
          "ssm:ResumeSession",
          "ssm:TerminateSession"
        ]
        Resource = "arn:aws:ec2:*:*:instance/*"
        Condition = {
          StringEquals = {
            "ssm:resourceTag/SSMAccess" = "true"
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:DescribeSessions",
          "ssm:GetConnectionStatus"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_restricted_ssm" {
  role       = aws_iam_role.devops_role.name
  policy_arn = aws_iam_policy.restricted_ssm_access.arn
}