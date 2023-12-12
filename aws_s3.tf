# 
# S3 BUCKET - PRIVATE (for materials)
# 

resource "aws_s3_bucket" "bucket" {
  bucket = "noteally-bucket"
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership_controls" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

# Enable cors for the bucket
resource "aws_s3_bucket_cors_configuration" "bucket_cors_configuration" {
  bucket = aws_s3_bucket.bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}



# 
# S3 BUCKET - PUBLIC (user profile pictures)
# 

resource "aws_s3_bucket" "public_bucket" {
  bucket = "noteally-public-bucket"
}

resource "aws_s3_bucket_ownership_controls" "public_bucket_ownership_controls" {
  bucket = aws_s3_bucket.public_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public_bucket_public_access_block" {
  bucket = aws_s3_bucket.public_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "public_bucket_acl" {
  depends_on = [
    aws_s3_bucket_public_access_block.public_bucket_public_access_block,
    aws_s3_bucket_ownership_controls.public_bucket_ownership_controls,
  ]

  bucket = aws_s3_bucket.public_bucket.id
  acl    = "public-read"
}
