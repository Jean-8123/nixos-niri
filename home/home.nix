{ config, pkgs, ... }:

{
  xdg.configFile."niri/config.kdl".source = ./niri-config.kdl;

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
    wlogout
    mako
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
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
        height = 36;
        
        margin-top = 0;
        margin-left = 0;
        margin-right = 0;
        
        modules-left = [ "niri/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "battery" "power-profiles-daemon" "custom/power" ];

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

        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          tooltip = true;
          format-icons = {
            default = "⚡";      # ASCII statt Nerd Font Icons zum Testen
            performance = "🚀";
            balanced = "⚖️";
            power-saver = "🔋";
          };
        };
        "custom/power" = {
          format = "⏻";
          tooltip = false;
          on-click = "wlogout -b 2";
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

