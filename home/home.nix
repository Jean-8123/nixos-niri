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
  # Wlogout Konfiguration (HyprNova Style für Niri)
  # ==========================================================================
  # Icons kopieren
  xdg.configFile."wlogout/icons/power.png".source        = ../assets/wlogout-icons/power.png;
  xdg.configFile."wlogout/icons/power-hover.png".source  = ../assets/wlogout-icons/power-hover.png;
  xdg.configFile."wlogout/icons/restart.png".source      = ../assets/wlogout-icons/restart.png;
  xdg.configFile."wlogout/icons/restart-hover.png".source = ../assets/wlogout-icons/restart-hover.png;
  xdg.configFile."wlogout/icons/logout.png".source       = ../assets/wlogout-icons/logout.png;
  xdg.configFile."wlogout/icons/logout-hover.png".source = ../assets/wlogout-icons/logout-hover.png;
  xdg.configFile."wlogout/icons/lock.png".source         = ../assets/wlogout-icons/lock.png;
  xdg.configFile."wlogout/icons/lock-hover.png".source   = ../assets/wlogout-icons/lock-hover.png;
  xdg.configFile."wlogout/icons/sleep.png".source        = ../assets/wlogout-icons/sleep.png;
  xdg.configFile."wlogout/icons/sleep-hover.png".source  = ../assets/wlogout-icons/sleep-hover.png;

  xdg.configFile."wlogout/layout".text = ''
    {
        "label" : "shutdown",
        "action" : "systemctl poweroff",
        "text" : "Shutdown",
        "keybind" : "s"
    }
    {
        "label" : "reboot",
        "action" : "systemctl reboot",
        "text" : "Reboot",
        "keybind" : "r"
    }
    {
        "label" : "logout",
        "action" : "niri msg action quit",
        "text" : "Logout",
        "keybind" : "e"
    }
    {
        "label" : "suspend",
        "action" : "systemctl suspend",
        "text" : "Suspend",
        "keybind" : "u"
    }
    {
        "label" : "lock",
        "action" : "swaylock",
        "text" : "Lock",
        "keybind" : "l"
    }
  '';

  xdg.configFile."wlogout/style.css".text = ''
    /* ═══════════════════════════════════════════════════════════════════
     * Wlogout - HyprNova Style (angepasst für NixOS/Niri)
     * ═══════════════════════════════════════════════════════════════════ */

    window {
      font-family: "JetBrainsMono Nerd Font", monospace;
      font-size: 14pt;
      color: #c0caf5;
      background-color: rgba(24, 27, 32, 0.85);
    }

    button {
      background-repeat: no-repeat;
      background-position: center;
      background-size: 20%;
      background-color: transparent;
      animation: gradient_f 20s ease-in infinite;
      transition: all 0.3s ease-in;
      box-shadow: 0 0 10px 2px transparent;
      border: none;
      border-radius: 36px;
      margin: 10px;
    }

    button:focus {
      box-shadow: none;
      background-size: 20%;
    }

    button:hover {
      background-size: 35%;
      box-shadow: 0 0 10px 3px rgba(0, 0, 0, 0.4);
      background-color: rgba(187, 154, 247, 0.3);
      transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682), box-shadow 0.5s ease-in;
    }

    #shutdown {
      background-image: image(url("./icons/power.png"));
    }
    #shutdown:hover {
      background-image: image(url("./icons/power-hover.png"));
    }

    #reboot {
      background-image: image(url("./icons/restart.png"));
    }
    #reboot:hover {
      background-image: image(url("./icons/restart-hover.png"));
    }

    #logout {
      background-image: image(url("./icons/logout.png"));
    }
    #logout:hover {
      background-image: image(url("./icons/logout-hover.png"));
    }

    #suspend {
      background-image: image(url("./icons/sleep.png"));
    }
    #suspend:hover {
      background-image: image(url("./icons/sleep-hover.png"));
    }

    #lock {
      background-image: image(url("./icons/lock.png"));
    }
    #lock:hover {
      background-image: image(url("./icons/lock-hover.png"));
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
    impala  # TUI WiFi Manager
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
          on-click            = "kitty --title 'WiFi Manager' impala";
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
          on-click = "wlogout -b 5 -T 400 -B 400 --protocol layer-shell";
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

      # Clock Format
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

