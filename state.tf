terraform {
  backend "s3" {
    bucket         = "erumble-tf-state"
    key            = "eks.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-state-lock"
  }
}
