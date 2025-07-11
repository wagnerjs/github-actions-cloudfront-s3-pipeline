resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "CloudFront Origin Access Identity for S3 bucket"
}

locals {
  s3_origin_id = "S3Origin"
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  enabled             = var.cloudfront.enabled
  default_root_object = var.cloudfront.default_root_object

  default_cache_behavior {
    allowed_methods  = var.cloudfront.allowed_methods
    cached_methods   = var.cloudfront.cached_methods
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = var.cloudfront.viewer_protocol_policy
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = var.cloudfront.name
  }
}
