provider "aws" {
  region  = "ap-northeast-1"
  version = "2.20.0"
}

data "aws_caller_identity" "current" { }

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}