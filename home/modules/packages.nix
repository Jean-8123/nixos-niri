{ config, pkgs, lib, ... }:

{
  # ==========================================================================
  # User-Pakete
  # ==========================================================================
  # Entfernt gegenüber dem Waybar-Setup: mako, swww, waypaper, swayidle,
  # wlogout, swaylock(-effects) und fuzzel. Diese Funktionen (Notifications,
  # Wallpaper, Idle, Session-Menü, Lockscreen, Launcher) bringt Noctalia
  # jetzt selbst mit; ein Parallelbetrieb wäre sogar schädlich, weil Noctalia
  # `org.freedesktop.Notifications` und `org.kde.StatusNotifierWatcher`
  # exklusiv beansprucht.
  programs.java.package = pkgs.jdk25;
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
    # Hinweis: beide Portal-Backends sind installiert, aber es gibt keine
    # `xdg.portal`-Konfiguration, die sie registriert. Noctalia selbst braucht
    # keine Portale; diese Pakete stehen hier für niri/Screensharing.
    # Redundanz siehe Bericht.
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
    udiskie

    # Hardware-Tasten aus home/niri-config.kdl
    # Diese drei fehlten bisher, obwohl die Binds sie seit jeher aufrufen -
    # Medien- und Helligkeitstasten waren dadurch faktisch wirkungslos.
    # `wpctl` kommt aus WirePlumber (services.pipewire in configuration.nix).
    brightnessctl   # XF86MonBrightnessUp/Down
    playerctl       # XF86AudioPlay/Stop/Prev/Next
    wl-clipboard    # wl-copy/wl-paste, u.a. fuer Screenshots

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
}
