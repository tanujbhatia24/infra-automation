output "frontend_url" {
  value = "http://${aws_instance.ecommerce.public_ip}"
}
