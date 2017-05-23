module "cattle_hosts" {
  source          = "../modules/generic-cluster/"
  prefix          = "rancher-cattle"
  keypair         = "${var.keypair}"
  network_id      = "${module.core_rancher.net_id}"
  security_groups = ["${openstack_compute_secgroup_v2.rancher_provider.name}", "${openstack_compute_secgroup_v2.rancher_consumer.name}","${openstack_compute_secgroup_v2.rancher_hosts.name}","${openstack_compute_secgroup_v2.allow_ssh.name}","${openstack_compute_secgroup_v2.allow_http_https.name}"]
}

output "rancher_cattle_hosts_internal" {
  value = "${module.cattle_hosts.generic_cluster_internal}"
}

output "rancher_cattle_hosts_external" {
  value = "${module.cattle_hosts.generic_cluster_external}"
}
