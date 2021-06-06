resource "aws_route53_zone" "example" {
  name = "sasaki-terraform-training.tk"
}

resource "aws_route53_record" "example" {
  zone_id = aws_route53_zone.example.zone_id
  name = aws_route53_zone.example.name
  type = "A"

  alias {
    name = aws_lb.example.dns_name
    zone_id = aws_lb.example.zone_id
    evaluate_target_health = true
  }
}

output "domain_name" {
  value = aws_route53_record.example.name
}