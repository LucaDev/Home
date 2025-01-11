{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot.initrd.clevis = {
    enable = true;
    useTang = true;
    devices."nixos".secretFile = ""; # TODO
  };
}
