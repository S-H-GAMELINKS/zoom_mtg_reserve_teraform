resource "aws_s3_bucket" "zoom-recoding-bucket" {
  bucket = "zoom-recoding-bucket"
  acl    = "private"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.zoom-recoding-bucket.id
}