# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "homeserver";
  networking.useDHCP = true;

  boot = {
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    initrd.kernelModules = [ ];
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "uas"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    initrd.luks.devices = {
      "nixos" = {
        device = "/dev/disk/by-uuid/77d87996-d1d2-4076-96ac-5d150f579486";
        allowDiscards = true;
        bypassWorkqueues = true;
        keyFileSize = 4096;
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/e988b69c-60f1-49ff-9c36-9dcb917b97bf";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/6AA3-9507";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    "/mnt/data" = {
      device = "/dev/disk/by-uuid/58220e85-242c-4f31-ae73-a94b68c22094";
      fsType = "bcachefs";
    };
  };

  swapDevices = [ ];
  hardware.cpu.amd.updateMicrocode = true;
  hardware.graphics.enable = true;
}
