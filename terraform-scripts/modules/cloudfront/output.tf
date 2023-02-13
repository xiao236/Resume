output "domain_name" {
    value = aws_cloudfront_distribution.cf-dist.domain_name
}
output "hosted_zone_id" {
    value = aws_cloudfront_distribution.cf-dist.hosted_zone_id
}