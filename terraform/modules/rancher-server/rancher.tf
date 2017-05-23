variable "prefix" {}
variable "keypair" {}
variable "count" {
  type = "string"
  default = "1"
}
variable "image" {
  type = "string"
  default = "ubuntu-16.04.2-server-20170224"
}
variable "flavor" {
  type = "string"
  default = "m1.small"
}
variable "network_id" {}
variable "az" {
  type = "string"
  default = "se-sthlm-1a"
}
variable "security_groups" {
  type = "list"
}

variable "cloudconfig_rancher" {
  type = "string"
  default = <<EOF
#cloud-config
apt_update: true
apt_upgrade: true
packages:
  - htop
runcmd:
  - curl https://releases.rancher.com/install-docker/1.12.sh | sh
  - docker run -d --privileged=true --restart=always -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock -v /.ssh:/.ssh rancher/server
power_state:
  mode: reboot
  message: Reboot required
  timeout: 30
  condition: True
EOF
}

# Make sure that these instances won't land on same physical hardware, if you run more than one instance
resource "openstack_compute_servergroup_v2" "srvgrp" {
  name = "${var.prefix}-srvgrp"
  policies = ["anti-affinity"]
}

resource "openstack_compute_floatingip_v2" "rancher_server_fip" {
  count = "${var.count}"
  pool = "ext-net-01"
}

resource "openstack_compute_floatingip_associate_v2" "rancher_server_as_fip" {
  count = "${var.count}"
  floating_ip = "${element(openstack_compute_floatingip_v2.rancher_server_fip.*.address, count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.rancher.*.id, count.index)}"
}

resource "openstack_compute_instance_v2" "rancher" {
  name = "${var.prefix}-srv${count.index+1}"
  count = "${var.count}"
  config_drive = "true"
  image_name = "${var.image}"
  flavor_name = "${var.flavor}"
  scheduler_hints {
      group = "${openstack_compute_servergroup_v2.srvgrp.id}"
  }
  network = { 
    uuid = "${var.network_id}"
  }

  key_pair = "${var.keypair}"
  security_groups = ["${var.security_groups}"]
  user_data = "${var.cloudconfig_rancher}"
  availability_zone = "${var.az}"
}

output "external_address" {
  value = "${join(",", openstack_compute_floatingip_v2.rancher_server_fip.*.address)}"
}

output "internal_address" {
  value = "${join(",", openstack_compute_floatingip_v2.rancher_server_fip.*.fixed_ip)}"
}
