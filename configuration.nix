{ config, pkgs, ... }:

{
  # ==========================================================================
  # Boot
  # ==========================================================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ==========================================================================
  # Netzwerk
  # ==========================================================================
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  # ==========================================================================
  # SSH & Sicherheit
  # ==========================================================================
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";
  services.fail2ban.enable = true;

  # ==========================================================================
  # Zeit & Sprache
  # ==========================================================================
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT    = "de_DE.UTF-8";
    LC_MONETARY       = "de_DE.UTF-8";
    LC_NAME           = "de_DE.UTF-8";
    LC_NUMERIC        = "de_DE.UTF-8";
    LC_PAPER          = "de_DE.UTF-8";
    LC_TELEPHONE      = "de_DE.UTF-8";
    LC_TIME           = "de_DE.UTF-8";
  };

  # ==========================================================================
  # Tastatur & Eingabe
  # ==========================================================================
  services.xserver.xkb = {
    layout  = "de";
    variant = "";
  };
  console.keyMap = "de";

  # ==========================================================================
  # Power Management
  # ==========================================================================
  services.power-profiles-daemon.enable = true;

  # ==========================================================================
  # Bluetooth
  # ==========================================================================
  hardware.bluetooth.enable      = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable        = true;

  # ==========================================================================
  # Benutzer
  # ==========================================================================
  users.users.jean = {
    isNormalUser = true;
    description  = "Jean";
    extraGroups  = [ "networkmanager" "wheel" ];
  };

  # ==========================================================================
  # Nix Einstellungen
  # ==========================================================================
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ==========================================================================
  # System-Programme
  # ==========================================================================
  programs.niri.enable = true;
  services.fwupd.enable = true;

  environment.systemPackages = with pkgs; [
    git
    neovim
    xwayland-satellite
  ];

  environment.variables = {
    EDITOR      = "nvim";
    SUDO_EDITOR = "nvim";
  };

  # ==========================================================================
  # Fonts
  # ==========================================================================
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # ==========================================================================
  # Stylix (Theming)
  # ==========================================================================
  stylix = {
    enable       = true;
    image        = ./assets/NixOS_Black_Sun.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity     = "dark";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name    = "JetBrainsMono Nerd Font";
      };
      sizes.terminal = 12;
    };

    opacity = {
      terminal     = 0.9;   # Terminals (Alacritty, Kitty, Foot, etc.)
      applications = 0.95;  # Normale Anwendungen (z.B. Brave)
      desktop      = 0.85;  # Desktop-Elemente (Waybar, etc.)
      popups       = 1.0;   # Popups/Tooltips
    };

    cursor = {
      name    = "catppuccin-mocha-dark-cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size    = 16;
    };
  };

  system.stateVersion = "25.11";
}

