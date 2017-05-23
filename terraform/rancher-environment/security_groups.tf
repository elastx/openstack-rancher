resource "openstack_compute_secgroup_v2" "rancher_provider" {
  name = "rancher-provider"
  description = "Provides access to Rancher. Members in rancher-consumer and a trusted cidr"
  rule {
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
    from_group_id = "${openstack_compute_secgroup_v2.rancher_consumer.id}"
  }
  rule {
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
    from_group_id = "${openstack_compute_secgroup_v2.rancher_consumer.id}"
  }
  rule {
    from_port = 8080
    to_port = 8080
    ip_protocol = "tcp"
    from_group_id = "${openstack_compute_secgroup_v2.rancher_consumer.id}"
  }
  rule {
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
    cidr = "${var.trusted_cidr}"
  }
  rule {
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
    cidr = "${var.trusted_cidr}"
  }
  rule {
    from_port = 8080
    to_port = 8080
    ip_protocol = "tcp"
    cidr = "${var.trusted_cidr}"
  }
}

resource "openstack_compute_secgroup_v2" "rancher_consumer" {
  name = "rancher-consumer"
  description = "members in this group can consume ssh serrvices which is in the ssh_provider group"
}

resource "openstack_compute_secgroup_v2" "rancher_hosts" {
  name = "rancher-hosts"
  description = "All instances using this group is in a rancher environment communication through ipsec"
}

resource "openstack_networking_secgroup_rule_v2" "rancher_hosts_rule_1" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "udp"
  port_range_min = 500
  port_range_max = 500
  security_group_id = "${openstack_compute_secgroup_v2.rancher_hosts.id}"
}

resource "openstack_networking_secgroup_rule_v2" "rancher_hosts_rule_2" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "udp"
  port_range_min = 4500
  port_range_max = 4500
  security_group_id = "${openstack_compute_secgroup_v2.rancher_hosts.id}"
}

resource "openstack_compute_secgroup_v2" "allow_ssh" {
  name = "allow-ssh"
  description = "Provides ssh access to trusted cidr"
  rule {
    from_port = 22 
    to_port = 22
    ip_protocol = "tcp"
    cidr = "${var.trusted_cidr}"
  }
}

resource "openstack_compute_secgroup_v2" "allow_http_https" {
  name = "allow-http-https"
  description = "Provides http and https access to InterNet"
  rule {
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
  rule {
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
}
