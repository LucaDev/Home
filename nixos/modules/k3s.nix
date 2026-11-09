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
      "--disable=local-storage"
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

  # runc-systemd for rw cgroup
  systemd.tmpfiles.rules = [
    "L+ /var/lib/rancher/k3s/agent/etc/containerd/config-v3.toml.tmpl - - - - ${pkgs.writeText "config-v3.toml.tmpl" ''
      {{ template "base" . }}

      [plugins.'io.containerd.cri.v1.runtime'.containerd.runtimes.runc-systemd]
        runtime_type = "io.containerd.runc.v2"
        cgroup_writable = true

      [plugins.'io.containerd.cri.v1.runtime'.containerd.runtimes.runc-systemd.options]
        SystemdCgroup = {{ .SystemdCgroup }}
    ''}"
  ];
}
