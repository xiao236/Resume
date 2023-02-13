module "s3" {
    source = "./modules/s3"
}

module "cloudfront" {
    source = "./modules/cloudfront"
    website_endpoint = module.s3.website_endpoint
    domain = var.domain
}

module "route53" {
    source = "./modules/route53"
    domain = var.domain
    cf_dns = module.cloudfront.domain_name
    cf_zone = module.cloudfront.hosted_zone_id
}