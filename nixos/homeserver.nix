{
  config,
  lib,
  pkgs,
  ...
}:

{
  #boot.initrd.extraUtilsCommands = ''
  #  copy_bin_and_libs ${pkgs.curl}/bin/curl
  #  cp -rpv ${pkgs.openssl}/lib/* $out/lib/
  #'';

  #boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
  #  curl <redacted> -o /tmp/key
  #'';

  #boot.initrd.luks.devices."nixos" = {
  #  keyFile = "/tmp/key";
  #  preLVM = false; # If this is true the decryption is attempted before the postDeviceCommands can run
  #};

  networking.hostName = "homeserver";

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.defaultSopsFile = ./secrets.sops.yaml;
  sops.secrets.backup_server = { };
  sops.secrets.backup_password = { };
  sops.secrets.ldap-pw = {
    sopsFile = ./ldap-pw.sops.txt;
    format = "binary";
    owner = "nslcd";
  };

  users.ldap = {
    enable = true;
    server = "ldaps://idm.lucadev.de/";
    base = "dc=idm,dc=lucadev,dc=de";
    daemon.enable = true;
    bind.distinguishedName = "dn=token";
    bind.passwordFile = config.sops.secrets.ldap-pw.path;
    daemon.extraConfig = "nss_initgroups_ignoreusers = ALLLOCAL";
  };

  services.fwupd.enable = true;

  # UPS monitoring
  power.ups = {
    enable = true;
    mode = "standalone";
    ups.main = {
      port = "/dev/ttyUSB0";
      driver = "apcsmart";
    };
    upsmon.monitor.homeserver.powerValue = 1;
    upsmon.monitor.homeserver.user = "admin";
    upsmon.monitor.homeserver.passwordFile = "/dev/null";
  };

  services.cron = {
    enable = true;
    systemCronJobs = [
      "4 4 * * 3   root   sshpass ${config.sops.secrets.backup_password.path} rsync -a /mnt/data/cached/single/timemachine-luca/ $(cat ${config.sops.secrets.backup_server.path}):./timemachine --progress -e 'ssh -p23' --bwlimit=15M"
    ];
  };

  # Samba server
  services.samba = {
    enable = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "%h";
        "server role" = "standalone server";
        "printcap name" = "/dev/null";
        "load printers" = "no";
        "security" = "user";
        "guest ok" = "no";
        "vfs objects" = "catia fruit streams_xattr";
        "fruit:metadata" = "stream";
        "fruit:model" = "MacSamba";
        "fruit:posix_rename" = "yes";
        "fruit:veto_appledouble" = "no";
        "fruit:nfs_aces" = "no";
        "fruit:wipe_intentionally_left_blank_rfork" = "yes";
        "fruit:delete_empty_adfiles" = "yes";
        "fruit:copyfile" = "yes";
        "fruit:encoding" = "native";
        "server multi channel support" = "yes";
        "server min protocol" = "NT1";
        "use sendfile" = "yes";
        "getwd cache" = "yes";
        "min receivefile size" = "16384";
      };

      home = {
        "path" = "/mnt/data/cached/single/homes/%U";
        "writeable" = "true";
        "root preexec" = "mkdir /mnt/data/cached/single/homes/%U";
      };

      public = {
        "path" = "/mnt/data/cached/single/public-share";
        "public" = "yes";
        "writeable" = "true";
        "guest ok" = "yes";
      };

      luca-timemachine = {
        "path" = "/mnt/data/cached/single/timemachine-luca";
        "valid users" = "lucadev";
        "writeable" = "true";
        "fruit:time machine" = "yes";
        "fruit:time machine max size" = "2T";
      };

      paperless-ingest = {
        "path" = "/tmp/paperless-ingest";
        "public" = "yes";
        "writeable" = "true";
        "guest ok" = "yes";
      };

      media = {
        "path" = "/mnt/data/hdd/single/media";
        "public" = "yes";
        "writable" = "true";
        "valid users" = "lucadev";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  # systemd.tmpfiles.rules = [ "L+ /var/lib/rancher/k3s - - - - /mnt/data/ssd/dual/k3s" ];

  services.k3s = {
    enable = true;
    gracefulNodeShutdown.enable = true;
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

  powerManagement.powertop.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "without-password";
    };
  };

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
