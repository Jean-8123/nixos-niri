{ config, pkgs, ... }:

{
  imports = [
    ./niri.nix
  ];

  home.username = "jean";
  home.homeDirectory = "/home/jean";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  # Session-Variablen
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GTK_THEME = "Adwaita:dark";
    TERMINAL = "kitty";
  };

  # User-Pakete
  home.packages = with pkgs; [
    # Browser
    (brave.override { commandLineArgs = "--ozone-platform=wayland"; })
    
    # Terminal & Tools
    kitty
    alacritty
    fastfetch
    btop
    ripgrep
    fd
    unzip
    lazygit

    # Wayland/niri
    swaylock
    swayidle
    swww
    waypaper
    mako
    udiskie

    # Entwicklung
    nodejs
    gcc
    
    # Apps
    localsend
    pavucontrol
    networkmanagerapplet
    qbittorrent
    protonvpn-gui
    krita
    aseprite
    
    # Gaming
    heroic
    lutris-unwrapped
  ];

  # Kitty
  programs.kitty = {
    enable = true;
  };

  # Waybar (nur EINMAL!)
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = [ "niri/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "battery" ];

        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%A, %d. %B %Y}";
          tooltip-format = "<tt>{calendar}</tt>";
        };

        battery = {
          format = "{icon} {capacity}%";
          format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          format-charging = "󰂄 {capacity}%";
        };

        network = {
          format-wifi = "󰖩 {essid}";
          format-ethernet = "󰈀 {ipaddr}";
          format-disconnected = "󰖪";
          tooltip-format = "{ifname}: {ipaddr}";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          format-icons = {
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          on-click = "pavucontrol";
        };
      };
    };
  };

  # Fuzzel
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "kitty";
      };
    };
  };
}

