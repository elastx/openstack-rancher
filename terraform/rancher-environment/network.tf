module "core_rancher" {
  source = "../modules/core-net"
  prefix_env = "rancher"
  ip_cidr = "10.16.0.0/24"
}

output "net_id" {
  value = "${module.core_rancher.net_id}"
}

