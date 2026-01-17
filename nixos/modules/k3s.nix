{
  config,
  lib,
  pkgs,
  ...
}:

{
#  systemd.tmpfiles.rules = [ "L+ /var/lib/rancher/k3s - - - - /mnt/data/ssd/dual/k3s" ];

  services.k3s = {
    enable = true;
    gracefulNodeShutdown = {
      enable = true;
      shutdownGracePeriod = "3m";
    };
    extraFlags = [
#      "--data-dir /mnt/data/ssd/dual/k3s"
      "--flannel-backend=none"
      "--disable-network-policy"
      "--disable-kube-proxy"
      "--disable=servicelb"
      "--disable=traefik"
      "--tls-san homeserver.home.lucadev.de"
      "--cluster-cidr=10.42.0.0/16,fd00:42::/56"
      "--service-cidr=10.43.0.0/16,fd00:43::/112"
      "--nonroot-devices"
      "--kube-controller-manager-arg=controllers=*,-node-ipam-controller"
    ];
  };

  systemd.services.k3s = {
    requires = [ "mnt-data.mount" ];
    after = [ "mnt-data.mount" ];
  };
}
