data "aws_acm_certificate" "cert" {
  domain      = "komissarkeishabride.com"
  statuses    = ["ISSUED"]
  most_recent = true
}

resource "aws_acm_certificate_validation" "dns_validation" {
  certificate_arn         = data.aws_acm_certificate.cert.arn
  validation_record_fqdns = aws_route53_record.www.records
}

data "aws_route53_zone" "main" {
  name         = "komissarkeishabride.com"  ## The domain name you want to look up
  private_zone = false
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "komissarkeishabride.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}