{
  config,
  lib,
  pkgs,
  ...
}:

{
  systemd.network = {
    enable = true;
    networks."lan" = {
      matchConfig.Name = "enp1s0";
      linkConfig.RequiredForOnline = "routable";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      vlan = ["vlanIOT"];
    };

    networks."vlanIOT" = {
      matchConfig.Name = "vlanIOT";
      networkConfig = {
        DHCP = "ipv4";
      };
    };

    netdevs = {
      "vlanIOT" = {
        netdevConfig = {
        Kind = "vlan";
        Name = "vlanIOT";
      };
      vlanConfig.Id = 100;
    };
  };
}
