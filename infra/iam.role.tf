resource "aws_iam_role_policy" "this" {
  name = var.github_assume_role_policy.name
  role = aws_iam_role.this.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "Statement1",
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:PutObject"
        ],
        Resource = [
          aws_s3_bucket.this.arn,
          "${aws_s3_bucket.this.arn}/*"
        ]
      },
      {
        Sid    = "Statement2",
        Effect = "Allow",
        Action = [
          "cloudfront:CreateInvalidation",
          "cloudfront:ListDistributions",
          "cloudfront:ListTagsForResource"
        ],
        Resource = [
          aws_cloudfront_distribution.this.arn,
        ]
      }
    ]
  })
}

resource "aws_iam_role" "this" {
  name = var.github_assume_role.name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.this.arn
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_assume_role.repo}:*"
          }
        }
      }
    ]
  })
}
