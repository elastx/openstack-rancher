module "rancher_server" {
  source          = "../modules/rancher-server/"
  prefix          = "rancher"
  keypair         = "${var.keypair}"
  network_id      = "${module.core_rancher.net_id}"
  security_groups = ["${openstack_compute_secgroup_v2.rancher_provider.name}", "${openstack_compute_secgroup_v2.rancher_consumer.name}","${openstack_compute_secgroup_v2.rancher_hosts.name}","${openstack_compute_secgroup_v2.allow_ssh.name}"]
}

output "rancher_ui" {
  value = "http://${module.rancher_server.external_address}:8080/"
}

output "rancher_api_base_url" {
  value = "http://${module.rancher_server.internal_address}:8080/"
}
