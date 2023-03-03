module "s3" {
    source = "./modules/s3"
}

module "cloudfront" {
    source = "./modules/cloudfront"
    website_endpoint = module.s3.website_endpoint
    origin_id = module.s3.id
    domain = var.domain
}

module "route53" {
    source = "./modules/route53"
    domain = var.domain
    cf_dns = module.cloudfront.domain_name
    cf_zone = module.cloudfront.hosted_zone_id
}

module "dynamodb" {
    source = "./modules/dynamo"
}

module "lambda" {
    source = "./modules/lambda"
    db_arn = module.dynamodb.db_arn
}

module "api-gateway" {
    source = "./modules/api-gateway"
    get_arn = module.lambda.get_arn
    put_arn = module.lambda.put_arn
    test_arn = module.lambda.test_arn
}