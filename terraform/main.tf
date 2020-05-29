#
terraform {
  required_version = ">=0.12.0"
}

output "MyHelloTerraform" {
  value = "This is my first hello in terraform"
}

provider "openstack" {
  user_name   = "test"
  tenant_name = "test"
  password    = "test123"
  auth_url    = "http://172.16.140.20:5000"
  region      = "RegionOne"
}


#resource "openstack_networking_network_v2" "webserver_network" {
#  name           = "webserver_network"
#  admin_state_up = "true"
#}
#
#resource "openstack_networking_subnet_v2" "webserver_subnet" {
#  name       = "webserver_subnet"
#  network_id = "${openstack_networking_network_v2.webserver_network.id}"
#  cidr       = "10.10.0.0/24"
#  ip_version = 4
#}



resource "openstack_compute_instance_v2" "haproxy" {
  count		  = 2
  name            = "haproxy-${count.index+1}"
  image_id        = "0b8d36b6-ef75-4a88-b286-1036afd31703"
  flavor_id       = "4cf0e1d6-a8df-451b-bdb1-988b5e1b411f"
  key_pair        = "jump-host"
  security_groups = ["default"]
#  depends_on = ["openstack_networking_subnet_v2.webserver_subnet"]

  network {
    name = "External-Network"
  }
}

resource "openstack_compute_instance_v2" "webserver" {
  count 	  = 4
  name            = "webserver-${count.index+1}"
  image_id        = "0b8d36b6-ef75-4a88-b286-1036afd31703"
  flavor_id       = "4cf0e1d6-a8df-451b-bdb1-988b5e1b411f"
  key_pair        = "jump-host"
  security_groups = ["default"]
#  depends_on = ["openstack_networking_subnet_v2.webserver_subnet"]
  network {
    name = "External-Network"
  }
}
