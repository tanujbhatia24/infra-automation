output "public_ip" {
  value = aws_instance.ecommerce.public_ip
}

output "frontend_url" {
  value = "http://${aws_instance.ecommerce.public_ip}:3000"
}

output "user_service_url" {
  value = "http://${aws_instance.ecommerce.public_ip}:3001/health"
}

output "product_service_url" {
  value = "http://${aws_instance.ecommerce.public_ip}:3002/health"
}

output "order_service_url" {
  value = "http://${aws_instance.ecommerce.public_ip}:3003/health"
}

output "cart_service_url" {
  value = "http://${aws_instance.ecommerce.public_ip}:3004/health"
}
