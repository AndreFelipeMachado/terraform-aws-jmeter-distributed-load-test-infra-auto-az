# JMeter Distributed Load Testing Infrastructure on AWS using Terraform

This repo will help you to spin up an AWS EC2 instances with Java, JMeter, and JMeter Plugins for distributed load testing.

## Prerequisites

* Terraform
* AWS Console w/ IAM role

## Setup

### AWS Key Pair

* Log into AWS console
* Navigate to EC2 -> Key Pairs
* Create a new key pair w/ RSA and Private Key format (PEM)  
* Save the private key to a file in a secure location

## Usage example with some variables.

```hcl
module "jmeter-distributed-load-test-infra" {
  source  = "AndreFelipeMachado/jmeter-distributed-load-test-infra-auto-az/aws/"
#  source  = "./terraform-aws-jmeter-distributed-load-test-infra-auto-az"

  # insert the required variables here
  aws_region                   = "sa-east-1"
  aws_exclude_names            = "sa-east-1b"
  aws_cidr                     = "10.0.0.0/16"
  aws_profile                  = "myprofilename"
  aws_ami                      = "ami-09bc0685970d93c8d"
  aws_key_name                 = "sandboxkey2"
  jmeter_version               = "5.6.3"
  jmeter_cmdrunner_version     = "2.3"
  jmeter_plugins_manager_version = "1.9"
  jmeter_workers_count         = 2
  aws_controller_instance_type = "t2.small"
  aws_worker_instance_type     = "t2.small"
  jmeter_plugins               = ["jpgc-casutg"]
  #Debian 12 ARM user=admin. Attention to compatible instance type architecture instance type
  aws_influxdb_grafana_ami     = "ami-0f55e4ab27ee52c57"
  aws_influxdb_grafana_instance_type = "m7g.large" #ARM
  aws_influxdb_grafana_instance_root_disk_size = "10"
  aws_influxdb_grafana_instance_root_disk_type = "gp3"
  aws_influxdb_grafana_instance_root_disk_encryption = false
  #Do not use heap size > 32GB as it will disable compressed Ordinary Object Pointers (OOPs)
  jmeter_controller_heap_size_ram_percentage = "-XX:MaxRAMPercentage=70"
}
```

By default, it will spin up an `t2.small` [not a free tier] instance with `sa-east-1` availability zone. Refer to the [AWS documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-types.html) for more information.
You may configure bigger Jmeter controller and influxdb_grafana instance types for your workloads and increase Jmeter worker count.
But pay attention to java heap size and minimal available ram for OS and other services.
Check the max heap size at the jmeter controller ec2 with the command
java -XX:+PrintFlagsFinal -version | grep HeapSize


At this version, the "public_subnet_cidrs" is the only type used at code, ignoring "private_subnet_cidrs" config.

To configure other input variables, refer to the [documentation](https://registry.terraform.io/modules/QAInsights/jmeter/aws/latest?tab=inputs#optional-inputs).

To configure [outputs](outputs.tf), refer to the [documentation](https://registry.terraform.io/modules/QAInsights/jmeter/aws/latest?tab=outputs).

## Terraform Plan and Apply

* Run `terraform init`
* Run `terraform plan`
* Run `terraform apply` when prompted to continue, enter `yes` to spin up the instance

## JMeter Execution

* Collect all the IP addresses of the JMeter controller and workers. Create `outputs.tf` to store the IP addresses.
* SSH into the JMeter controller and run the following command to start JMeter:

```sh
jmeter -n -t apache-jmeter-5.6.3/bin/examples/CSVSample.jmx -R <worker-IP-address-1,worker-IP-address-2...> \ 
-l run1.log -Dserver.rmi.ssl.disable=true
```

## JMeter validation

ssh into the instance using the PEM and run `jmeter -v` to verify JMeter is installed and working.

## Grafana dashboards
Configure security group to your IP and connect to the public url of the jmeter_influxdb_grafana ec2 port 3000.
Change the default admin:admin login immediately at your first connection to a strong password.
Configure the data source to http://localhost:8086 influxdb jmeter database without any user:password.
You could develop your own dashboard or start from an available dashboard import compatible with influxdb v1.x, for example
[example Jmeter Grafana dashboard for influxdb v1.x](https://grafana.com/grafana/dashboards/5496-apache-jmeter-dashboard-by-ubikloadpack/)


## Reference

* [Terraform](https://www.terraform.io/)
* [AWS](http://aws.amazon.com/)
* [Apache JMeter](https://jmeter.apache.org/)
* [InfluxDB](https://www.influxdata.com/)
* [Grafana](https://grafana.com/)
