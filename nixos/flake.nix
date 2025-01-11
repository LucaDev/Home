{
  description = "NixOS Homeserver";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      sops-nix,
      ...
    }@inputs:
    {
      nixosConfigurations.homeserver = nixpkgs.lib.nixosSystem {
        modules = [
          ./hardware/homeserver.nix
          ./modules/base.nix
          ./modules/secrets.nix
          ./modules/power.nix
          ./modules/k3s.nix
          ./modules/samba.nix
          sops-nix.nixosModules.sops
        ];
      };
      nixosConfigurations.iso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ./modules/base.nix
        ];
      };
    };
}
