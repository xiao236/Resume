resource "aws_s3_bucket" "website" {
  bucket = "damixiaoresumebucket"
}

data "aws_s3_bucket" "helper" {
  bucket = "state-file-resume"
}

resource "aws_s3_bucket_policy" "publicaccess" {
  bucket = aws_s3_bucket.website.id
  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.website.arn}/*"
        }
    ]
}
  EOF
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.website.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "version" {
  bucket = aws_s3_bucket.website.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "staticweb" {
    depends_on = [aws_s3_object.index_doc, aws_s3_object.style_doc]
    bucket = aws_s3_bucket.website.bucket
    index_document {
        suffix = "index.html"
    }
}

resource "aws_s3_object" "index_doc" {
  key        = "index.html"
  bucket     = aws_s3_bucket.website.id
  source     = "../index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "style_doc" {
  key        = "style.css"
  bucket     = aws_s3_bucket.website.id
  source     = "../style.css"
  content_type = "text/css"
}

resource "aws_s3_object" "handler_file" {
  key        = "handlerFiles/handler.py"
  bucket     = data.aws_s3_bucket.helper.id
  source     = "../handler.py"
  content_type = "text/x-python"
}