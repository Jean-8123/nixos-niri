{
  description = "Jean's NixOS Configuration";

  # ==========================================================================
  # Inputs (Externe Abhängigkeiten)
  # ==========================================================================
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # ==========================================================================
  # Outputs (System-Konfigurationen)
  # ==========================================================================
  outputs = { self, nixpkgs, stylix, home-manager, ... }: {
    nixosConfigurations.LT-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        # System-Konfiguration
        ./configuration.nix
        ./hosts/LT-hardware.nix
        ./modules/nvidia.nix

        # Stylix Theming
        stylix.nixosModules.stylix

        # Host-spezifische Einstellungen
        { networking.hostName = "LT-nixos"; }

        # Home-Manager Integration
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs        = true;
          home-manager.useUserPackages      = true;
          home-manager.users.jean           = import ./home/home.nix;
          home-manager.backupFileExtension  = "backup";
        }
      ];
    };
  };
}

