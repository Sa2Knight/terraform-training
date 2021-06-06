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

resource "aws_route53_record" "example_certificate" {
  name = aws_acm_certificate.example.domain_validation_options[0].resource_record_name
  type = aws_acm_certificate.example.domain_validation_options[0].resource_record_type
  records = [aws_acm_certificate.example.domain_validation_options[0].resource_record_value]
  zone_id = aws_route53_zone.example.zone_id
  ttl = 60
}

resource "aws_acm_certificate" "example" {
  domain_name = aws_route53_zone.example.name
  subject_alternative_names = []
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn = aws_acm_certificate.example.arn
  validation_record_fqdns = [ aws_route53_record.example_certificate.fqdn]
}

output "domain_name" {
  value = aws_route53_record.example.name
}