output "website_endpoint" {
    value = aws_s3_bucket_website_configuration.staticweb.website_endpoint
}

output "id" {
    value = aws_s3_bucket_website_configuration.staticweb.id
}

output "test" {
    value = aws_s3_bucket.website.bucket_regional_domain_name
}