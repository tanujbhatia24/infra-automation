output "public_ip" {
  value = aws_instance.ecommerce.public_ip
}

output "frontend_url" {
  value = "http://${aws_instance.ecommerce.public_ip}:3000"
}
