resource "aws_route53domains_registered_domain" "damixiao" {
    domain_name = var.domain
}

data "aws_route53_zone" "primary" {
    zone_id = "Z0852599310F6T2Q2JOSY"
}

resource "aws_route53_record" "www" {
    zone_id = data.aws_route53_zone.primary.zone_id
    name    = var.domain
    type    = "A"

    alias {
        name                   = var.cf_dns
        zone_id                = var.cf_zone
        evaluate_target_health = false
    }
}