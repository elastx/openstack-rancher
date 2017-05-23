# Change this to a trusted IP

variable "trusted_cidr" {
  type    = "string"
  default = "0.0.0.0/0"
}

variable "keypair" {
  type    = "string"
  default = "id_rsa-rancher"
}

# this is just informational
output "ssh_username" {
  value = "ubuntu"
}
