output "flask_public_ip" {
  value = aws_instance.flask_instance.public_ip
}

output "express_public_ip" {
  value = aws_instance.express_instance.public_ip
}
