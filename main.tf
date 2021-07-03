resource "aws_s3_bucket" "a" {
  bucket = "erumble-test-bucket-a"
  acl    = "private"
}

resource "aws_s3_bucket" "b" {
  bucket = "erumble-test-bucket-b"
  acl    = "private"
}
