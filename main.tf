provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
#  version = "5.19" #deprecated feature
}

resource "aws_instance" "jmeter_main" {
  count                  = var.jmeter_main_count
  ami                    = var.aws_ami
  instance_type          = var.aws_controller_instance_type
  key_name               = var.aws_key_name
  subnet_id              = element(module.vpc.public_subnets, count.index)
  vpc_security_group_ids = [aws_security_group.jmeter_security_group.id]
  user_data = templatefile("${path.module}/install-jmeter.sh", {
    JMETER_HOME                         = var.jmeter_home,
    JMETER_VERSION                      = var.jmeter_version,
    JMETER_DOWNLOAD_URL                 = "https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${var.jmeter_version}.tgz",
    JMETER_CMDRUNNER_VERSION            = var.jmeter_cmdrunner_version,
    JMETER_CMDRUNNER_DOWNLOAD_URL       = "http://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/${var.jmeter_cmdrunner_version}/cmdrunner-${var.jmeter_cmdrunner_version}.jar",
    JMETER_PLUGINS_MANAGER_VERSION      = var.jmeter_plugins_manager_version,
    JMETER_PLUGINS_MANAGER_DOWNLOAD_URL = "https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-manager/${var.jmeter_plugins_manager_version}/jmeter-plugins-manager-${var.jmeter_plugins_manager_version}.jar",
    JMETER_PLUGINS                      = join(",", var.jmeter_plugins),
    JMETER_MODE                         = "leader",
    JMETER_CONTROLLER_HEAP_SIZE_RAM_PERCENTAGE = var.jmeter_controller_heap_size_ram_percentage
  })
  tags = {
    Name = "jmeter_controller"
  }


}
