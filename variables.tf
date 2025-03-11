variable "aws_profile" {
  default = "default"
}

variable "aws_region" {
  default = "sa-east-1"
}
variable "aws_exclude_names"{
  default = null
  type = string
  description = "Exclude an AZ because of a missing feature. Default: null"
}

variable "aws_cidr" {
  type = string
  default = "10.0.0.0/16"
  description = "VPC CIDR value. Default : 10.0.0.0/16"
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
  description = "ID of AMI to use for the instance available at chosen region"
  type        = string
  default     = null
  validation {
    condition     = length(var.aws_ami) > 4 && substr(var.aws_ami, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}
variable "aws_controller_instance_type" {
  
  type        = string
  default     = null
}
variable "aws_worker_instance_type" {
  description = "The type of worker instance(s) to start"
  type        = string
  default     = null
}
variable "aws_key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}

variable "jmeter_home" {
  description = "The location of the home directory"
  type        = string
  default     = "/home/ec2-user"
}

variable "jmeter_version" {
  description = "The version of JMeter to install"
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