locals {
    s3_origin_id = "damixiaoWebsite"
}

resource "aws_cloudfront_distribution" "cf-dist" {
    origin {
        origin_id = local.s3_origin_id
        domain_name = var.website_endpoint
    }
    enabled             = true
    is_ipv6_enabled     = true

    price_class = "PriceClass_100"

    aliases = ["damixiao.net"]

    default_cache_behavior {
        allowed_methods  = ["GET", "HEAD", "OPTIONS"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = local.s3_origin_id
        compress = true
        viewer_protocol_policy = "redirect-to-https"

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
