provider "aws" {
  region  = "ap-northeast-1"
  version = "2.20.0"
}

resource "aws_s3_bucket" "examples" {
  count = 5
  bucket = "sasaki-terraform-test-${count.index}"
  acl    = "private"

  tags = {
    Name        = "My bucket ${count.index}"
  }
}