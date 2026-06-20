output "ec2_public_ip" {
  description = "IP Publico da instancia EC2"
  value       = aws_instance.web.public_ip
}

output "rds_endpoint" {
  description = "Endpoint do banco RDS MySQL"
  value       = aws_db_instance.myapp_db.endpoint
}
