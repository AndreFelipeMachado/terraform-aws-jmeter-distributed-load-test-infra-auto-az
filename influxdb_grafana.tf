resource "aws_instance" "influxdb_grafana"{
# Debian 12 user=admin. Attention to compatible instance type architecture
  #ami = "ami-0360d1397581bdace" #intel
  ami = var.aws_influxdb_grafana_ami
  #instance_type = "m7i.large" #intel
  instance_type = var.aws_influxdb_grafana_instance_type
  key_name = var.aws_key_name
  count = var.jmeter_influxdb_count
  subnet_id              = element(module.vpc.public_subnets, count.index)
  vpc_security_group_ids = [aws_security_group.jmeter_security_group.id]

  tags = {
      Name = "jmeter_influxdb_grafana"
  }

  user_data = templatefile("${path.module}/install-influxdb-grafana.sh", {
    INFLUXDB_VERSION                      = var.jmeter_influxdb_version
    }
  )

  root_block_device {
        delete_on_termination = true
        encrypted   = var.aws_influxdb_grafana_instance_root_disk_encryption
        volume_size = var.aws_influxdb_grafana_instance_root_disk_size
        volume_type = var.aws_influxdb_grafana_instance_root_disk_type
  }
}