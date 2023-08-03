output "public_ip_of_demo" {
  description = "this is public IP"
  value = aws_instance.demo.public_ip
}

output "private_ip_of_demo" {
  description = "this is public IP"
  value = aws_instance.demo.private_ip
}