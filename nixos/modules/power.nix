{
  config,
  lib,
  pkgs,
  ...
}:

{
  # UPS
  power.ups = {
    enable = true;
    mode = "netserver";
    upsd.listen = [{address = "*";}];
    users.upsmon = {
      upsmon = "primary";
      instcmds = [
        "ALL"
      ];
      actions = [
        "SET"
        "FSD"
      ];
      passwordFile = config.sops.secrets.upsmon_password.path;
    };
    ups.rack = {
      description = "Eaton 5P 1550";
      port = "192.168.1.72";
      driver = "snmp-ups";
    };
    upsmon.monitor.rack = {
      powerValue = 1;
      user = "upsmon";
      passwordFile = config.sops.secrets.upsmon_password.path;
    };
  };

  systemd.services."upsdrv" = {
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "90s";
    };
  };


  powerManagement.powertop.enable = true;
}
