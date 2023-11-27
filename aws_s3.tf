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
