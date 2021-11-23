########## Variables ##########
variable "sk" {
  type       = string
}
variable "ak" {
  type       = string
}
########## Configure the HUAWEI CLOUD provider ##########
provider "huaweicloud" {
  region     = "sa-argentina-1"
  access_key = var.ak
  secret_key = var.sk
}

########## Data ##########
data "huaweicloud_availability_zones" "myaz" {}

data "huaweicloud_compute_flavors" "myflavor" {
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  performance_type  = "normal"
  cpu_core_count    = 2
  memory_size       = 4
}

data "huaweicloud_images_image" "myimage" {
  name        = "CentOS 7.9 64bit"
  most_recent = true
}

########## Create vpc & Network ##########

resource "huaweicloud_vpc" "vpc" {
  name = "vpc_pg"
  cidr = "192.168.0.0/16"
}
resource "huaweicloud_vpc_subnet" "pgsubnet" {
  name       = "pgsubnet"
  cidr       = "192.168.0.0/16"
  gateway_ip = "192.168.0.1"
  vpc_id     = huaweicloud_vpc.vpc.id
}
resource "huaweicloud_vpc_eip" "pgeip" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "mybandwidth"
    size        = 8
    share_type  = "PER"
    charge_mode = "traffic"
  }
}
resource "huaweicloud_compute_eip_associate" "associated" {
  public_ip   = huaweicloud_vpc_eip.pgeip.address
  instance_id = huaweicloud_compute_instance.pgecs.id
}
resource "huaweicloud_networking_secgroup" "mysecgroup" {
  name        = "secgroup"
  description = "My security group"
}

resource "huaweicloud_networking_secgroup_rule" "secgroup_rule" {
  security_group_id = huaweicloud_networking_secgroup.mysecgroup.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8080
  port_range_max    = 8080
  remote_ip_prefix  = "0.0.0.0/0"
}

########## Create ECS ##########
data "huaweicloud_vpc_subnet" "pgsubnet" {
  name = "subnet-pg"
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!@#$%*"
}

resource "huaweicloud_compute_instance" "pgecs" {
  name              = "basic"
  admin_pass        = random_password.password.result
  image_id          = data.huaweicloud_images_image.myimage.id
  flavor_id         = data.huaweicloud_compute_flavors.myflavor.ids[0]
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  security_groups   = ["mysecgroup"]

  network {
    uuid = data.huaweicloud_vpc_subnet.pgsubnet.id
  }
}