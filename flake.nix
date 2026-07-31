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

    # Noctalia v5 (natives C++-Shell, ersetzt Waybar).
    # Der Branch `cachix` zeigt immer auf den zuletzt in den Binary-Cache
    # gebauten Commit — deshalb kein `main`.
    #
    # ACHTUNG: Hier absichtlich KEIN `inputs.nixpkgs.follows = "nixpkgs"`.
    # Ein Override von Noctalias Inputs verändert den Derivation-Hash und
    # macht damit jeden Treffer in noctalia.cachix.org zunichte. Noctalia v5
    # ist ein grosser meson/C++-Build, der dann lokal ca. 20 Minuten
    # kompilieren würde. Bitte nicht "hilfsbereit" nachrüsten.
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
    };
  };

  # ==========================================================================
  # Outputs (System-Konfigurationen)
  # ==========================================================================
  outputs = { self, nixpkgs, home-manager, stylix, noctalia, ... } @ inputs:
    let
      system = "x86_64-linux";

      # Beide Hosts unterscheiden sich nur in Hardware-Datei, Hostname und
      # optionalen Zusatzmodulen. Ein gemeinsamer Konstruktor verhindert,
      # dass Änderungen künftig nur in einem der beiden Blöcke landen.
      mkHost = { hostName, hardware, extraModules ? [ ] }:
        nixpkgs.lib.nixosSystem {
          inherit system;

          # Flake-Inputs nach unten durchreichen, damit Module direkt auf
          # z.B. `inputs.noctalia` zugreifen können, ohne sie erneut zu
          # importieren.
          specialArgs = { inherit inputs; };

          modules = [
            # System-Konfiguration
            ./configuration.nix
            hardware
            ./modules/nvidia.nix

            # Stylix Theming
            stylix.nixosModules.stylix

            # Host-spezifische Einstellungen
            { networking.hostName = hostName; }

            # Home-Manager Integration
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs       = true;
              home-manager.useUserPackages     = true;
              home-manager.backupFileExtension = "backup";

              # Dieselben Inputs auch auf der Home-Manager-Seite verfügbar
              # machen (dort wird u.a. die Stylix-Palette auf Noctalias
              # Farbrollen gemappt).
              home-manager.extraSpecialArgs = { inherit inputs; };

              # Stellt `programs.noctalia.*` für alle HM-Benutzer bereit.
              # Das Flake-Output heisst `homeModules` (Plural), nicht
              # `homeManagerModules`.
              home-manager.sharedModules = [ noctalia.homeModules.default ];

              home-manager.users.jean = import ./home;
            }
          ] ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        LT-nixos = mkHost {
          hostName     = "LT-nixos";
          hardware     = ./hosts/LT-hardware.nix;
          extraModules = [ ./modules/gaming.nix ];
        };

        # Bewusst ohne `./modules/gaming.nix`: auf dem zLT wird nicht
        # gespielt, Steam/Proton & Co. sollen dort nicht mitgebaut werden.
        zLT-nixos = mkHost {
          hostName     = "zLT-nixos";
          hardware     = ./hosts/zLT-hardware.nix;
          extraModules = [ ];
        };
      };
    };
}
