resource "aws_key_pair" "OpenVPN" {
  key_name = "openvpn"
  public_key = file("D:\\devops\\practice\\keys\\keys.pub")
}


resource "aws_instance" "name" {
  ami = local.ami
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.vpn]
  subnet_id = local.subnets
  key_name = aws_key_pair.OpenVPN.key_name
  user_data = file("openvpn.sh")

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-vpn"
    }
  )
}

resource "aws_route53_record" "vpn" {
  zone_id = var.zone_id
  name = "vpn-${var.environment}.${var.zone_name}"
  type = "A"
  ttl = "1"
  records = [aws_instance.name.public_ip]
  allow_overwrite = true
}