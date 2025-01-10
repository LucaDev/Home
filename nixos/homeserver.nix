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

  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    defaultSopsFile = ./secrets.sops.yaml;
    secrets = {
      backup_server = { };
      backup_password = { };
      upsmon_password = { };
      ldap_password = {
        sopsFile = ./ldap_password.sops.txt;
        format = "binary";
        owner = "nslcd";
      };
    };
  };

  users.ldap = {
    enable = true;
    server = "ldaps://idm.lucadev.de/";
    base = "dc=idm,dc=lucadev,dc=de";
    daemon = {
      enable = true;
      extraConfig = "nss_initgroups_ignoreusers = ALLLOCAL";
    };
    bind = {
      distinguishedName = "dn=token";
      passwordFile = config.sops.secrets.ldap_password.path;
    };
  };

  services.fwupd.enable = true;

  # UPS monitoring
  power.ups = {
    enable = true;
    mode = "netserver";
    users.upsmon = {
      upsmon = "primary";
      instcmds = "ALL";
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

  services.cron = {
    enable = true;
    systemCronJobs = [
      "4 4 * * 3   root   sshpass -f ${config.sops.secrets.backup_password.path} rsync -a /mnt/data/cached/single/timemachine-luca/ $(cat ${config.sops.secrets.backup_server.path}):./timemachine -e 'ssh -p23' --bwlimit=15M"
    ];
  };

  # Samba server
  services.samba = {
    enable = true;
    package = pkgs.samba4Full;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "%h";
        "printcap name" = "/dev/null";
        "load printers" = "no";
        "security" = "user";
        "guest ok" = "no";
        # macOS
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
        "server min protocol" = "NT1";
        # Performance
        "server multi channel support" = "yes";
        "use sendfile" = "yes";
        "getwd cache" = "yes";
        "min receivefile size" = "16384";
        "socket options" = "IPTOS_LOWDELAY TCP_NODELAY IPTOS_THROUGHPUT SO_RCVBUF=131072 SO_SNDBUF=131072";
        "deadtime" = "60";
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
    extraOptions = [ "--preserve-case" ];
    interface = "enp1s0";
    openFirewall = true;
  };

  services.avahi = {
    enable = true;
    allowInterfaces = [ "enp1s0" ];
    publish = {
      enable = true;
      userServices = true;
    };
    ipv6 = true;
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
  services.openssh.settings = {
    PermitRootLogin = "without-password";
    PasswordAuthentication = false;
  };

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
