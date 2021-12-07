###############################
########## Variables ##########
###############################

variable "sk" {
  type       = string
}
variable "ak" {
  type       = string
}

##################################
########## HUAWEI CLOUD ##########
##################################

provider "huaweicloud" {
  region     = "sa-argentina-1"
  access_key = var.ak
  secret_key = var.sk
}

##########################
########## Data ##########
##########################

data "huaweicloud_availability_zones" "myaz" {}

data "huaweicloud_compute_flavors" "pg-flavor" {
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  performance_type  = "highmem"
  cpu_core_count    = 2
  memory_size       = 4
}

data "huaweicloud_images_image" "myimage" {
  name        = "CentOS 7.9 64bit"
  most_recent = true
}

###################################
########## vpc & Network ##########
###################################

resource "huaweicloud_vpc" "pgvpc" {
  name = "pgvpc"
  cidr = "192.168.0.0/16"
}
resource "huaweicloud_vpc_subnet" "pg-subnet" {
  name       = "pg-subnet"
  cidr       = "192.168.0.0/24"
  gateway_ip = "192.168.0.1"
  vpc_id     = huaweicloud_vpc.pgvpc.id
}

########################
########## SG ##########
########################

resource "huaweicloud_networking_secgroup" "pg-secgroup" {
  name        = "pg-secgroup"
  description = "My security group"
}
resource "huaweicloud_networking_secgroup_rule" "secgroup_rule" {
  security_group_id = huaweicloud_networking_secgroup.pg-secgroup.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
}
resource "huaweicloud_networking_secgroup_rule" "https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup.pg-secgroup.id
}
resource "huaweicloud_networking_secgroup_rule" "http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup.pg-secgroup.id
}
resource "huaweicloud_networking_secgroup_rule" "http1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8080
  port_range_max    = 8080
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup.pg-secgroup.id
}


#########################
########## ECS ##########
#########################

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!@#$%*"
}

resource "huaweicloud_evs_volume" "pg-vol" {
  name              = "pg-volume"
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  volume_type       = "SSD"
  size              = 50
}

resource "huaweicloud_compute_instance" "pg-ecs" {
  name               = "pg-ecs"
  admin_pass         = random_password.password.result
  image_id           = data.huaweicloud_images_image.myimage.id
  flavor_id          = data.huaweicloud_compute_flavors.pg-flavor.id
  security_groups    = ["pg-secgroup"]
  availability_zone  = data.huaweicloud_availability_zones.myaz.names[0]

  network {
    uuid = huaweicloud_vpc_subnet.pg-subnet.id
  }
}

resource "huaweicloud_compute_volume_attach" "pg-attached" {
  instance_id = huaweicloud_compute_instance.pg-ecs.id
  volume_id   = huaweicloud_evs_volume.pg-vol.id
}

###############################
########## EIP & NAT ##########
###############################

resource "huaweicloud_nat_gateway" "pg-nat" {
  name                = "pg-nat"
  spec                = "1"
  router_id           = huaweicloud_vpc.pgvpc.id
  internal_network_id = huaweicloud_vpc_subnet.pg-subnet.id
}

resource "huaweicloud_nat_dnat_rule" "pg-dnat_1" {
  nat_gateway_id        = huaweicloud_nat_gateway.pg-nat.id
  floating_ip_id        = "3fceb686-7435-4c6a-8332-a4171ee0d398"
  port_id               = huaweicloud_compute_instance.pg-ecs.network.0.port
  protocol              = "tcp"
  internal_service_port = 22
  external_service_port = 22
}
resource "huaweicloud_nat_dnat_rule" "pg-dnat_2" {
  nat_gateway_id        = huaweicloud_nat_gateway.pg-nat.id
  floating_ip_id        = "3fceb686-7435-4c6a-8332-a4171ee0d398"
  port_id               = huaweicloud_compute_instance.pg-ecs.network.0.port
  protocol              = "tcp"
  internal_service_port = 80 
  external_service_port = 80
}
resource "huaweicloud_nat_dnat_rule" "pg-dnat_3" {
  nat_gateway_id        = huaweicloud_nat_gateway.pg-nat.id
  floating_ip_id        = "3fceb686-7435-4c6a-8332-a4171ee0d398"
  port_id               = huaweicloud_compute_instance.pg-ecs.network.0.port
  protocol              = "tcp"
  internal_service_port = 8080 
  external_service_port = 8080
}
resource "huaweicloud_nat_dnat_rule" "pg-dnat_4" {
  nat_gateway_id        = huaweicloud_nat_gateway.pg-nat.id
  floating_ip_id        = "3fceb686-7435-4c6a-8332-a4171ee0d398"
  port_id               = huaweicloud_compute_instance.pg-ecs.network.0.port
  protocol              = "tcp"
  internal_service_port = 443 
  external_service_port = 443
}