output "instance_public_ip" {
  description = "Public IP of the Flask + Express EC2 instance"
  value       = aws_instance.flask_express_server.public_ip
}

output "flask_url" {
  description = "URL for Flask app"
  value       = "http://${aws_instance.flask_express_server.public_ip}:5000"
}

output "express_url" {
  description = "URL for Express app"
  value       = "http://${aws_instance.flask_express_server.public_ip}:3000"
}

output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i <path-to-your-private-key.pem> ubuntu@${aws_instance.flask_express_server.public_ip}"
}
