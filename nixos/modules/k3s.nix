{
  config,
  lib,
  pkgs,
  ...
}:

{
  systemd.tmpfiles.rules = [ "L+ /var/lib/rancher/k3s - - - - /mnt/data/ssd/dual/k3s" ];

  services.k3s = {
    enable = true;
    gracefulNodeShutdown = {
      enable = true;
      shutdownGracePeriod = "2m";
    };
    extraFlags = [
      "--data-dir /mnt/data/ssd/dual/k3s"
      "--flannel-backend=none"
      "--disable-network-policy"
      "--disable-kube-proxy"
      "--disable=servicelb"
      "--disable=traefik"
      "--tls-san homeserver.home.lucadev.de"
    ];
  };
}
