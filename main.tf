provider "aws" {
  region  = "ap-northeast-1"
  version = "2.20.0"
}

data "aws_elb_service_account" "current" { }

output "account_id" {
  value = data.aws_elb_service_account.current.id
}