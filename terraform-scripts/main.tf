module "s3" {
    source = "./modules/s3"
}

module "cloudfront" {
    source = "./modules/cloudfront"
    website_endpoint = module.s3.website_endpoint
}