{ config, pkgs, lib, ... }:

{
  # ==========================================================================
  # Modul-Einbindung
  # ==========================================================================
  # Einstiegspunkt für Home-Manager. `flake.nix` bindet dieses Verzeichnis über
  # `home-manager.users.jean = import ./home;` ein, deshalb muss default.nix ein
  # vollwertiges Modul sein. Alles Fachliche liegt in ./modules, damit ein
  # Umbau (z. B. Waybar -> Noctalia) nur eine Datei betrifft.
  # Kein eigenes Theming-Modul: Stylix bringt seit Mitte 2026 ein eigenes
  # Noctalia-Target mit und erzeugt Palette, Modus, Schrift, Wallpaper-Pfad
  # und Opacity selbst. Siehe Kommentar in ./modules/noctalia.nix.
  imports = [
    ./modules/noctalia.nix
    ./modules/niri.nix
    ./modules/terminal.nix
    ./modules/packages.nix
    ./modules/filemanager.nix
  ];

  # ==========================================================================
  # Home-Manager Grundeinstellungen
  # ==========================================================================
  home.username      = "jean";
  home.homeDirectory = "/home/jean";

  # stateVersion bleibt bewusst auf "25.05": sie beschreibt, gegen welche
  # Home-Manager-Defaults die Konfiguration ursprünglich geschrieben wurde.
  # Ein Hochziehen würde stillschweigend Verhalten ändern.
  home.stateVersion  = "25.05";

  programs.home-manager.enable = true;

  # ==========================================================================
  # Session-Variablen
  # ==========================================================================
  home.sessionVariables = {
    # Erzwingt natives Wayland in Chromium/Electron-Apps (Brave, Discord, ...).
    NIXOS_OZONE_WL = "1";

    # Fallback für GTK-Apps, die das Stylix-Theme nicht selbst auswerten.
    GTK_THEME      = "Adwaita:dark";

    # Wird von Tools wie xdg-open / Editoren als Terminal-Emulator benutzt.
    TERMINAL       = "kitty";

    # Explizit gesetzt, damit Wayland-Apps (PrismLauncher) JAVA_HOME finden.
    # programs.java setzt dies nur für Login-Shells; hier wird es als
    # Session-Variable für alle Prozesse der Niri-Session verfügbar gemacht.
    JAVA_HOME      = "${pkgs.jdk25}";
  };
}
