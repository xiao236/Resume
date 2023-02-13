resource "aws_cloudfront_distribution" "cf-dist" {
    origin {
        origin_id = var.origin_id
        domain_name = var.website_endpoint
        custom_origin_config {
            http_port              = "80"
            https_port             = "443"
            origin_protocol_policy = "match-viewer"
            origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
        }
    }
    enabled             = true
    is_ipv6_enabled     = true

    price_class = "PriceClass_100"

    aliases = ["damixiao.net"]

    default_cache_behavior {
        allowed_methods  = ["GET", "HEAD", "OPTIONS"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = var.origin_id
        compress = true
        viewer_protocol_policy = "redirect-to-https"
        cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    }
    restrictions {
        geo_restriction {
            restriction_type = "none"
            locations        = []
        }
    }

    viewer_certificate {
        acm_certificate_arn = "arn:aws:acm:us-east-1:044230928495:certificate/af4df3bb-e96c-4276-ac40-844fcc586e0e"
        minimum_protocol_version = "TLSv1.2_2021"
        ssl_support_method = "sni-only"
    }

    retain_on_delete = true
}
