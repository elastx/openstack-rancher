variable "prefix_env" {}
variable "ip_cidr" {}

# Use google DNS if DNS resolvers are missing
variable "dns" {
  type = "list"
  default =  ["8.8.8.8","8.8.4.4"]
}

# Use Elastx default gw if it isn't provided
variable "gw" {
  type = "string"
  default = "62954df1-05bb-42e5-9960-ca921cccaeeb"
}

resource "openstack_networking_router_v2" "router" {
  name = "${var.prefix_env}-router"
  admin_state_up = "true"
  external_gateway = "${var.gw}"
}

resource "openstack_networking_network_v2" "net" {
  name = "${var.prefix_env}-net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet" {
  name = "${var.prefix_env}-subnet"
  network_id = "${openstack_networking_network_v2.net.id}"
  cidr = "${var.ip_cidr}"
  ip_version = 4
  enable_dhcp = "true"
  dns_nameservers = "${var.dns}" 
}

resource "openstack_networking_router_interface_v2" "ext-interface" {
  router_id = "${openstack_networking_router_v2.router.id}"
  subnet_id = "${openstack_networking_subnet_v2.subnet.id}"
}

output "net_id" {
  value = "${openstack_networking_network_v2.net.id}"
}

output "router_id" {
  value = "${openstack_networking_router_v2.router.id}"
}


