variable "aws_profile" {
  default = "default"
  description = "Your AWS user profile name."
}

variable "aws_region" {
  default = "sa-east-1"
  description = "Chosen AWS region."
}
variable "aws_exclude_names"{
  default = null
  type = string
  description = "Exclude an AZ because of a missing feature at your chosen region."
}

variable "aws_cidr" {
  type = string
  default = "10.0.0.0/16"
  description = "VPC CIDR value."
}

variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values with a public ip maped on launch"
 default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
 
variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values without a public ip maped on launch"
 default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "aws_ami" {
  description = "ID of AMI to use for the instance AVAILABLE AT CHOSEN REGION"
  type        = string
  default     = null
  validation {
    condition     = length(var.aws_ami) > 4 && substr(var.aws_ami, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\" available at your chosen region."
  }
}

variable "aws_controller_instance_type" {
  
  type        = string
  default     = null
  description = "The jmeter controller aws instance type."
}

variable "aws_worker_instance_type" {
  description = "The type of worker instance(s) to start."
  type        = string
  default     = null
}

variable "aws_key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}

variable "jmeter_home" {
  description = "The location of the home directory."
  type        = string
  default     = "/home/ec2-user"
}

variable "jmeter_version" {
  description = "The version of JMeter to install."
  default     = "5.4.3"
  type        = string
}

variable "jmeter_plugins" {
  type        = list(string)
  description = "List of JMeter plugins to install"
  default     = null
  
}

variable "jmeter_cmdrunner_version" {
  description = "The version of JMeter CommandRunner to install"
  default     = "2.2"
  type        = string
}

variable "jmeter_plugins_manager_version" {
  description = "The version of JMeter Plugins Manager to install"
  type        = string
  default     = "1.7"
}

variable "jmeter_mode" {
  description = "The mode of JMeter to run: leader or follower"
  default     = "follower"
  type        = string

}

variable "jmeter_workers_count" {
  description = "The number of worker nodes to run"
  default     = 1
  type        = number

  validation {
    condition     = (var.jmeter_workers_count) >= 1
    error_message = "The number of worker nodes must be greater than 0."
  }
}

variable "jmeter_main_count" {
  description = "The leader/controller node must be 1."
  default     = 1
  type        = number

  validation {
    condition     = var.jmeter_main_count == 1
    error_message = "The leader/controller node must be 1."
  }
} 

variable "jmeter_controller_heap_size_ram_percentage" {
  description = "The Jmeter controller heap size RAM percentage. Do not use heap size > 32GB as it will disable compressed Ordinary Object Pointers (OOPs)."
  type        = string
  default     = "-XX:MaxRAMPercentage=70"
}

variable "jmeter_influxdb_count" {
  description = "The influxdb OSS node must be 1."
  default     = 1
  type        = number
}

variable "jmeter_influxdb_version"{
  description = "The influxdb OSS version. Must be 1.x at this module version."
  default =  "1.11.8"
  type = string
}

variable "aws_influxdb_grafana_instance_type" {
  description = "The type of worker instance(s) to start."
  type        = string
  default     = "m7g.large" #arm
}

variable "aws_influxdb_grafana_ami" {
  # Debian 12 user=admin, beware of compatible instance type architecture
  description = "ID of AMI to use for the instance AVAILABLE AT CHOSEN REGION"
  type        = string
  default     = "ami-0f55e4ab27ee52c57"
  validation {
    condition     = length(var.aws_influxdb_grafana_ami) > 4 && substr(var.aws_influxdb_grafana_ami, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\" available at your chosen region."
  }
}

variable "aws_influxdb_grafana_instance_root_disk_size" {
  description = "The root disk size (GB) of influxdb-grafana instance(s) to start."
  type        = string
  default     = "8"
}

variable "aws_influxdb_grafana_instance_root_disk_type" {
  description = "The root disk type of influxdb-grafana instance(s) to start."
  type        = string
  default     = "gp3"
}

variable "aws_influxdb_grafana_instance_root_disk_encryption" {
  description = "The root disk encryption enable/disable of influxdb-grafana instance(s) to start."
  type        = bool
  default     = false
}
