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
  # Wlogout Konfiguration (Noctalia Theme)
  # ==========================================================================
  xdg.configFile."wlogout/layout".text = ''
    {
        "label" : "lock",
        "action" : "swaylock",
        "text" : "",
        "keybind" : "l"
    }
    {
        "label" : "logout",
        "action" : "niri msg action quit",
        "text" : "󰍃",
        "keybind" : "e"
    }
    {
        "label" : "suspend",
        "action" : "systemctl suspend",
        "text" : "󰤄",
        "keybind" : "u"
    }
    {
        "label" : "reboot",
        "action" : "systemctl reboot",
        "text" : "",
        "keybind" : "r"
    }
    {
        "label" : "shutdown",
        "action" : "systemctl poweroff",
        "text" : "",
        "keybind" : "s"
    }
  '';

  xdg.configFile."wlogout/style.css".text = ''
    /* ═══════════════════════════════════════════════════════════════════
     * Wlogout - Noctalia Minimal Theme (Nerd Font Icons)
     * ═══════════════════════════════════════════════════════════════════ */

    * {
      font-family: "JetBrainsMono Nerd Font", monospace;
      font-size: 48px;
    }

    window {
      background-color: rgba(12, 12, 12, 0.85);
    }

    button {
      color: #c0caf5;
      background-color: rgba(20, 20, 20, 0.8);
      border: 2px solid rgba(255, 255, 255, 0.08);
      border-radius: 16px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
      margin: 12px;
      transition: all 0.2s ease-in-out;
    }

    button:focus,
    button:active,
    button:hover {
      background-color: rgba(30, 30, 30, 0.95);
      outline-style: none;
    }

    #lock {
      color: #f7768e;
      border-color: rgba(247, 118, 142, 0.3);
    }
    #lock:hover {
      border-color: #f7768e;
      box-shadow: 0 0 24px 4px rgba(247, 118, 142, 0.35);
    }

    #logout {
      color: #ff9e64;
      border-color: rgba(255, 158, 100, 0.3);
    }
    #logout:hover {
      border-color: #ff9e64;
      box-shadow: 0 0 24px 4px rgba(255, 158, 100, 0.35);
    }

    #suspend {
      color: #e0af68;
      border-color: rgba(224, 175, 104, 0.3);
    }
    #suspend:hover {
      border-color: #e0af68;
      box-shadow: 0 0 24px 4px rgba(224, 175, 104, 0.35);
    }

    #reboot {
      color: #bb9af7;
      border-color: rgba(187, 154, 247, 0.3);
    }
    #reboot:hover {
      border-color: #bb9af7;
      box-shadow: 0 0 24px 4px rgba(187, 154, 247, 0.35);
    }

    #shutdown {
      color: #7dcfff;
      border-color: rgba(125, 207, 255, 0.3);
    }
    #shutdown:hover {
      border-color: #7dcfff;
      box-shadow: 0 0 24px 4px rgba(125, 207, 255, 0.35);
    }
  '';

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
    # swaylock wird über programs.swaylock installiert
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
    go
    python315

    # Apps
    localsend
    pavucontrol
    networkmanagerapplet
    krita
    aseprite
    discord
    spotify
    xxd
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

    # CSS basierend auf New-Niri-minimal-dots (minimalistisch)
    style = ''
      /* ═══════════════════════════════════════════════════════════════════
       * Waybar - Noctalia Minimal Theme (angepasst)
       * Basierend auf: github.com/youngcoder45/New-Niri-minimal-dots
       * ═══════════════════════════════════════════════════════════════════ */

      /* ───────── Global Styles ───────── */
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free", monospace;
        font-size: 11px;
        font-weight: 600;
        min-height: 0;
      }

      /* ───────── Window ───────── */
      window#waybar {
        background: transparent;
        color: #c0caf5;
        transition: none;
      }

      /* ───────── Common Module Styles ───────── */
      #workspaces,
      #clock,
      #pulseaudio,
      #network,
      #bluetooth,
      #battery,
      #power-profiles-daemon,
      #custom-power {
        padding: 2px 8px;
        margin: 1px 2px;
        background: rgba(20, 20, 20, 0.8);
        border-radius: 10px;
        border: 1px solid rgba(255, 255, 255, 0.05);
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        transition: all 0.2s ease;
      }

      /* Hover effects */
      #custom-power:hover,
      #bluetooth:hover,
      #power-profiles-daemon:hover {
        background: rgba(136, 192, 208, 0.3);
        border: 1px solid rgba(136, 192, 208, 0.4);
        box-shadow: 0 4px 12px rgba(136, 192, 208, 0.2);
      }

      /* ───────── Workspaces ───────── */
      #workspaces {
        padding: 0;
        background: transparent;
        border: none;
        box-shadow: none;
      }

      #workspaces button {
        padding: 2px 6px;
        margin: 0 1px;
        color: #b79bec;
        background: rgb(22, 21, 21);
        border-radius: 10px;
        border: 1px solid rgba(255, 255, 255, 0.05);
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        transition: all 0.2s ease;
        min-width: 22px;
      }

      #workspaces button.active {
        background: rgb(22, 21, 21);
        color: #f29fff;
        border: 0.8px solid rgba(160, 44, 255, 0.9);
      }

      #workspaces button:hover {
        background: rgba(0, 0, 0, 0.5);
        color: #f1baff;
        border: 1px solid rgba(9, 9, 9, 0.3);
      }

      /* ───────── Clock ───────── */
      #clock {
        font-weight: 600;
        color: #f1baff;
        background: rgba(20, 20, 20, 0.8);
        border: 1px solid rgba(136, 192, 208, 0.15);
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
      }

      /* ───────── Audio ───────── */
      #pulseaudio {
        color: #bb9af7;
      }

      #pulseaudio.muted {
        color: #bf616a;
        background: rgba(191, 97, 106, 0.1);
      }

      /* ───────── Network ───────── */
      #network {
        color: #88c0d0;
      }

      #network.disconnected {
        color: #bf616a;
        background: rgba(191, 97, 106, 0.1);
      }

      /* ───────── Bluetooth ───────── */
      #bluetooth {
        color: #88c0d0;
      }

      #bluetooth.connected {
        color: #bb9af7;
      }

      #bluetooth.off {
        color: #4c566a;
      }

      /* ───────── Battery ───────── */
      #battery {
        color: #bb9af7;
      }

      #battery.charging, #battery.plugged {
        color: #88c0d0;
        background: rgba(136, 192, 208, 0.1);
      }

      #battery.warning:not(.charging) {
        color: #ebcb8b;
        background: rgba(235, 203, 139, 0.1);
      }

      #battery.critical:not(.charging) {
        color: #bf616a;
        background: rgba(191, 97, 106, 0.1);
        animation: blink 1s infinite;
      }

      @keyframes blink {
        0% { opacity: 1; }
        50% { opacity: 0.5; }
        100% { opacity: 1; }
      }

      /* ───────── Power Profiles ───────── */
      #power-profiles-daemon {
        color: #88c0d0;
      }

      /* ───────── Power Button ───────── */
      #custom-power {
        color: #bf616a;
        font-size: 12px;
        padding-left: 10px;
        padding-right: 10px;
      }

      /* ───────── Tooltips ───────── */
      tooltip {
        background: rgba(20, 20, 20, 0.9);
        border: 1px solid rgba(255, 255, 255, 0.08);
        border-radius: 8px;
        padding: 10px;
      }

      tooltip label {
        color: #e5e9f0;
        font-size: 12px;
      }
    '';

    settings = {
      mainBar = {
        layer    = "top";
        position = "top";
        height   = 32;
        spacing  = 0;  # Module haben eigenes margin im CSS

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
  # Swaylock-Effects (Lockscreen mit Blur - Noctalia Theme)
  # ==========================================================================
  # Stylix für swaylock deaktivieren (wir verwenden eigenes Theme)
  stylix.targets.swaylock.enable = false;

  programs.swaylock = {
    enable  = true;
    package = pkgs.swaylock-effects;
    settings = {
      # Screenshots mit Effekten (wie Omarchy/hyprlock)
      screenshots         = true;
      clock               = true;
      indicator           = true;
      effect-blur         = "10x3";
      effect-vignette     = "0.3:0.8";
      fade-in             = 0.2;
      grace               = 2;

      # Farben (Noctalia Theme)
      inside-color       = "1a1b2600";
      inside-clear-color = "1a1b2600";
      inside-ver-color   = "1a1b2600";
      inside-wrong-color = "1a1b2600";

      line-color       = "00000000";
      line-clear-color = "00000000";
      line-ver-color   = "00000000";
      line-wrong-color = "00000000";

      ring-color       = "bb9af7";
      ring-clear-color = "e0af68";
      ring-ver-color   = "7dcfff";
      ring-wrong-color = "f7768e";

      key-hl-color = "bb9af7";
      bs-hl-color  = "f7768e";

      text-color       = "c0caf5";
      text-clear-color = "c0caf5";
      text-ver-color   = "7dcfff";
      text-wrong-color = "f7768e";

      separator-color = "00000000";

      # Indikator
      indicator-radius    = 120;
      indicator-thickness = 8;

      # Clock
      clock               = true;
      timestr             = "%H:%M";
      datestr             = "%A, %d. %B";

      # Font
      font      = "JetBrainsMono Nerd Font";
      font-size = 32;

      # Verhalten
      show-failed-attempts  = true;
      ignore-empty-password = true;
      daemonize             = true;
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

