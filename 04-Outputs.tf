output "Link_to_alias_domain_name"{
    value = "https://${data.aws_acm_certificate.cert.domain}"
}

output "Link_to_cloudfront_domain_name" {
  value = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
}