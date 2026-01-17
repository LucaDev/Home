{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Base Config
  system.rebuild.enableNg = true;

  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "+5";
    };
  };

  time.timeZone = "Europe/Berlin";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  security.lsm = lib.mkForce [];

  # Boot
  boot = {
    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "bcachefs" ];
    boot.bcachefs.package = pkgs-unstable.bcachefs-tools;

    initrd = {
      availableKernelModules = [
        "aesni_intel"
        "cryptd"
        "ixgbe"
      ];
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 22;
          authorizedKeys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILjUx5YA3RwdM0xfXY7KMZb3N3BrK1tDyJ/qcQQvBWJE luca@Laptop-von-Luca.local"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ1WsEPt50HcTjV5WY9g3NRlUVU7RH583ocFs+FzOK38 iPhone"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINMK9lqvQVrZvcmA4cxAeQRK0PygmpnzU0b+wTNZnnoC luca@luca-thinclient"
          ];
          hostKeys = [
            "/etc/secrets/initrd/ssh_host_rsa_key"
            "/etc/secrets/initrd/ssh_host_ed25519_key"
          ];
        };
      };
    };

    kernelParams = [
      "ip=dhcp"
      "init_on_alloc=0"
      "init_on_free=0"
      "mitigations=off"
      #"module_blacklist=r8169"
      "security=none"
    ];

    kernel.sysctl = {
      "user.max_user_namespaces" = 11255;
      "fs.inotify.max_user_watches" = 1048576;
      "fs.inotify.max_user_instances" = 8192;
      "net.core.default_qdisc" = "fq";
      "net.core.rmem_max" = 67108864;
      "net.core.wmem_max" = 67108864;
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_mtu_probing" = 1;
      "net.ipv4.tcp_rmem" = "4096 87380 33554432";
      "net.ipv4.tcp_wmem" = "4096 65536 33554432";
      "net.ipv4.tcp_window_scaling" = 1;
      "vm.nr_hugepages" = 512;
      "kernel.sysrq" = 1;
      "kernel.panic" = 120;  
    };

    kernelModules = [
      "ip6table_filter"
      "ip6_tables"
      "ip6table_mangle"
      "ip6table_raw"
      "iptable_nat"
      "ip6table_nat"
      "iptable_filter"
      "xt_socket"
    ];

    tmp.tmpfsHugeMemoryPages = "within_size";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -alh";
      rebuild = "nixos-rebuild switch --flake /root/homeserver/nixos/";
      update = "nix flake update --flake /root/homeserver/nixos/";
      repl = "nix repl -f flake:nixpkgs";
      gc = "nh clean --keep 5";
      fs = "bcachefs fs usage /mnt/data -h";
    };
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users."root".openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILjUx5YA3RwdM0xfXY7KMZb3N3BrK1tDyJ/qcQQvBWJE luca@Laptop-von-Luca.local"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ1WsEPt50HcTjV5WY9g3NRlUVU7RH583ocFs+FzOK38 iPhone"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINMK9lqvQVrZvcmA4cxAeQRK0PygmpnzU0b+wTNZnnoC luca@luca-thinclient"
    ];
  };

  environment = {
    variables.EDITOR = "vim";
    variables.KUBECONFIG = "/var/lib/rancher/k3s/server/cred/admin.kubeconfig";
    variables.CONTAINERD_ADDRESS = "/run/k3s/containerd/containerd.sock"; 
    systemPackages = with pkgs; [
      git
      vim
      wget
      smartmontools
      htop
      k9s
      screen
      nerdctl
      rsync
      sshpass
      sbctl
      nvtopPackages.amd
      btop
    ];
  };

  virtualisation.containers.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "without-password";
    settings.PasswordAuthentication = false;
  };

  services.fwupd.enable = true;
  services.envfs.enable = true;
  programs.nix-ld.enable = true;

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
