resource "aws_ssm_parameter" "acm" {
   name = "/${var.project}/${var.environment}/acm"
   type = "String"
   value = aws_acm_certificate.blackweb_agency.arn
}