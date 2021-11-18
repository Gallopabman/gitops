# Configure the HUAWEI CLOUD provider.
provider "huaweicloud" {
  region     = "sa-argentina-1"
  access_key = "LVAINUC7AJEEHXYFHSU7"
  secret_key = "Jm1S1sRVV4B6FXtTsgAlLBZ6c0SgVed46niy5RXm"
}

# Create a VPC.
resource "huaweicloud_vpc" "example" {
  name = "terraform_vpc"
  cidr = "192.168.0.0/16"
}

# Create ECS
data "huaweicloud_availability_zones" "myaz" {}

data "huaweicloud_compute_flavors" "myflavor" {
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  performance_type  = "normal"
  cpu_core_count    = 2
  memory_size       = 4
}

data "huaweicloud_images_image" "centos" {
  name        = "CentOS 7.9 64bit"
  most_recent = true
}

data "huaweicloud_vpc_subnet" "pablonet" {
  name = "subnet-default"
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!@#$%*"
}

resource "huaweicloud_compute_instance" "basic" {
  name              = "basic"
  admin_pass        = random_password.password.result
  image_id          = data.huaweicloud_images_image.centos.id
  flavor_id         = data.huaweicloud_compute_flavors.myflavor.ids[0]
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  security_groups   = ["default"]

  network {
    uuid = data.huaweicloud_vpc_subnet.pablonet.id
  }
}