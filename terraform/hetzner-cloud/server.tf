variable "talos_version" {default = "1.4.6"}

variable "image" {
  type = string
  default = "https://github.com/siderolabs/talos/releases/download/${var.talos_version}/hcloud-amd64.raw.xz"
}

resource "hcloud_server" "home-cluster-hetzner-node1" {
  name        = "home-cluster-hetzner-node1"
  image       = "debian-11"
  server_type = "cx11"
  datacenter  = "nbg1-dc3"
  rescue      = true
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get install -y wget",
      "wget -O /tmp/talos.raw.xz ${local.image}",
      "xz -d -c /tmp/talos.raw.xz | dd of=/dev/sda && sync",
      "reboot now"
    ]
  }
}
