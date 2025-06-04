{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking.firewall.enable = false;

  networking.useNetworkd = true;

  systemd.network = {
    enable = true;
    networks."10-enp1s0" = {
      matchConfig.Name = "enp1s0";
      linkConfig.RequiredForOnline = "routable";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      vlan = ["vlanIOT"];
    };

    networks."12-vlanIOT" = {
      matchConfig.Name = "vlanIOT";
      networkConfig = {
        DHCP = "ipv4";
      };
    };

    netdevs = {
      "11-vlanIOT" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlanIOT";
        };
        vlanConfig.Id = 100;
      };
    };
  };
}
