{ config, pkgs, ... }:

{
  # ==========================================================================
  # Home-Manager Grundeinstellungen
  # ==========================================================================
  home.username      = "jean";
  home.homeDirectory = "/home/jean";
  home.stateVersion  = "25.05";

  programs.home-manager.enable = true;

  # ==========================================================================
  # XDG Konfiguration (Niri Window Manager)
  # ==========================================================================
  xdg.configFile."niri/config.kdl".source = ./niri-config.kdl;

  # ==========================================================================
  # Session-Variablen
  # ==========================================================================
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GTK_THEME      = "Adwaita:dark";
    TERMINAL       = "kitty";
  };

  # ==========================================================================
  # User-Pakete
  # ==========================================================================
  home.packages = with pkgs; [
    # Browser
    (brave.override { commandLineArgs = "--ozone-platform=wayland"; })

    # Terminal & CLI Tools
    kitty
    alacritty
    fastfetch
    btop
    ripgrep
    fd
    unzip
    lazygit

    # Wayland/Niri Utilities
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

  ];

  # ==========================================================================
  # Terminal: Kitty
  # ==========================================================================
  programs.kitty = {
    enable = true;
  };

  # ==========================================================================
  # Waybar (Status-Leiste)
  # ==========================================================================
  programs.waybar = {
    enable = true;

    # CSS für Modul-Spacing (ergänzt Stylix)
    style = ''
      #custom-power {
        margin-left: 8px;
        padding-left: 12px;
        padding-right: 12px;
      }

      #power-profiles-daemon {
        padding-left: 8px;
        padding-right: 8px;
      }

      /* Allgemeines Spacing für rechte Module */
      .modules-right > widget > * {
        margin: 0 4px;
      }
    '';

    settings = {
      mainBar = {
        layer    = "top";
        position = "top";
        height   = 36;
        spacing  = 8;  # Globaler Abstand zwischen Modulen (in px)

        margin-top   = 0;
        margin-left  = 0;
        margin-right = 0;

        modules-left   = [ "niri/workspaces" ];
        modules-center = [ "clock" ];
        modules-right  = [ "pulseaudio" "network" "bluetooth" "battery" "power-profiles-daemon" "custom/power" ];

        clock = {
          format         = "{:%H:%M}";
          format-alt     = "{:%A, %d. %B %Y}";
          tooltip-format = "<tt>{calendar}</tt>";
        };

        battery = {
          format          = "{icon} {capacity}%";
          format-icons    = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          format-charging = "󰂄 {capacity}%";
        };

        network = {
          format-wifi         = "󰖩 {essid}";
          format-ethernet     = "󰈀 {ipaddr}";
          format-disconnected = "󰖪";
          tooltip-format      = "{ifname}: {ipaddr}";
        };

        bluetooth = {
          format           = "󰂯";
          format-connected = "󰂱 {device_alias}";
          format-off       = "󰂲";
          tooltip-format   = "{controller_alias}\n{num_connections} verbunden";
          on-click         = "blueman-manager";
        };

        pulseaudio = {
          format       = "{icon} {volume}%";
          format-muted = "󰝟";
          format-icons = {
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          on-click = "pavucontrol";
        };

        power-profiles-daemon = {
          format         = "{icon}";
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          tooltip        = true;
          format-icons   = {
            default     = "⚡";
            performance = "🚀";
            balanced    = "⚖️";
            power-saver = "🔋";
          };
        };

        "custom/power" = {
          format   = "⏻";
          tooltip  = false;
          on-click = "wlogout -b 2";
        };
      };
    };
  };

  # ==========================================================================
  # Fuzzel (App-Launcher)
  # ==========================================================================
  programs.fuzzel = {
    enable   = true;
    settings = {
      main = {
        terminal = "kitty";
      };
    };
  };
}

