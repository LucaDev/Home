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
      description = "Smart-UPS 750 RM";
      port = "/dev/usb/hiddev0";
      driver = "usbhid-ups";
    };
    upsmon.monitor.rack = {
      powerValue = 1;
      user = "upsmon";
      passwordFile = config.sops.secrets.upsmon_password.path;
    };
  };

  powerManagement.powertop.enable = true;
}
