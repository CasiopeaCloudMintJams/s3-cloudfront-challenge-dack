#### CloudFront Distribution ####

## 1. Set origin access identity for s3 bucket
resource "aws_cloudfront_origin_access_identity" "OAI" {
    comment = "OAI for s3 bucket"
}

## 2. Point OAC to s3 Bucket
##    
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {   
    domain_name              = aws_s3_bucket.bucketlist.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.bucketlist.id

  s3_origin_config {
    origin_access_identity   = aws_cloudfront_origin_access_identity.OAI.cloudfront_access_identity_path
   }
   
 }

  retain_on_delete    = false
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"
  http_version        = "http2"
  aliases             = ["komissarkeishabride.com"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.bucketlist.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = {
    Environment = "dev"
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.cert.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}