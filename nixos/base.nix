{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;
  networking.firewall.enable = false;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_stable;
  boot.supportedFilesystems = [ "bcachefs" ]; 

  boot.initrd = {
    availableKernelModules = [ "aesni_intel" "cryptd" "ixgbe" ];
    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 22;
        authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILjUx5YA3RwdM0xfXY7KMZb3N3BrK1tDyJ/qcQQvBWJE luca@Laptop-von-Luca.local" ];
        hostKeys = [ "/etc/secrets/initrd/ssh_host_rsa_key" "/etc/secrets/initrd/ssh_host_ed25519_key" ];
      };
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -alh";
      rebuild = "nixos-rebuild switch --flake ~/homeserver/nixos/";
      update = "nix flake update";
      repl = "nix repl -f flake:nixpkgs";
      gc = "nix-collect-garbage --delete-old";
    };
#    history.size = 10000;
  };

  users.defaultUserShell = pkgs.zsh;
  environment.variables.EDITOR = "vim";

  users.users."root".openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILjUx5YA3RwdM0xfXY7KMZb3N3BrK1tDyJ/qcQQvBWJE luca@Laptop-von-Luca.local"];

  # Kernel arguments
  boot.kernelParams = [
    "ip=dhcp"
    "init_on_alloc=0"
    "init_on_free=0"
    "mitigations=off"
    "module_blacklist=r8169"
    "security=none"
  ];
  
  # Sysctls
  boot.kernel.sysctl = {
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
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    smartmontools
    htop
    k9s
    screen 
    podman
    rsync
  ];
  
  # systemd.tmpfiles.rules = [ "L+ /var/lib/rancher/k3s - - - - /mnt/data/ssd/dual/k3s" ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
  };

  services.envfs.enable = true;
  programs.nix-ld.enable = true;

  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "+5";
  };

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
