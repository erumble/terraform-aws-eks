resource "aws_s3_bucket" "b" {
  bucket = "erumble-test-bucket"
  acl    = "private"
}
