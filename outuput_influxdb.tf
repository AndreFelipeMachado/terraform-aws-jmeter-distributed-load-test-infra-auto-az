output "influxdb_public_ip" {
  description = "The public IP address assigned to the influxdb instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = aws_instance.influxdb_grafana[0].public_ip
}
output "influxdb_private_ip" {
  description = "The private IP address assigned to the influxdb instance."
  value       = aws_instance.influxdb_grafana[0].private_ip
}

output "influxdb_state" {
  description = "The state of the influxdb instance. One of: `pending`, `running`, `shutting-down`, `terminated`, `stopping`, `stopped`"
  value       = aws_instance.influxdb_grafana[0].instance_state
}

output "influxdb_arn" {
  description = "The ARN of the influxdb instance"
  value       = aws_instance.influxdb_grafana[0].arn
}

output "jmeter_influxdb_version" {
  description = "JMeter version installed on the influxdb instance"
  value       = var.jmeter_influxdb_version
}

output "influxdb_instance_type" {
  description = "The type of instance running the influxdb"
  value       = aws_instance.influxdb_grafana[0].instance_type
  
}