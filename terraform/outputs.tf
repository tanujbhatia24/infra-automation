output "public_ip" {
  value = aws_instance.ecommerce.public_ip
}

output "frontend_url" {
  value = "http://${aws_instance.ecommerce.public_ip}:3000"
}

output "backend_services_urls" {
  value = "http://${aws_instance.ecommerce.public_ip}:3001/health"
  value = "http://${aws_instance.ecommerce.public_ip}:3002/health"
  value = "http://${aws_instance.ecommerce.public_ip}:3003/health"
  value = "http://${aws_instance.ecommerce.public_ip}:3004/health"
}
