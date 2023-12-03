# 
# S3 BUCKET
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
