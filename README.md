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
}
```

By default, it will spin up an `t2.small` [not a free tier] instance with `sa-east-1` availability zone. Refer to the [AWS documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-types.html) for more information.

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

## Reference

* [Terraform](https://www.terraform.io/)
* [AWS](http://aws.amazon.com/)
* [Apache JMeter](https://jmeter.apache.org/)
