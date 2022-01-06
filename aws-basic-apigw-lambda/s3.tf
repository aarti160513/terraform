resource "aws_s3_bucket" "bucket" {
  bucket = var.s3_lambda_bucket
  acl    = "private"
  versioning {
    enabled = false
  }
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.bucket.id
  key    = "hello-universe.zip"
  source = data.archive_file.lambda_hello_universe.output_path
  etag   = filemd5(data.archive_file.lambda_hello_universe.output_path)
}

resource "aws_s3_bucket_public_access_block" "bucket" {

  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
}

