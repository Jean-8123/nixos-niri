{ config, pkgs, ... }:

{
  # ==========================================================================
  # Gaming Konfiguration
  # ==========================================================================

  # Steam (benötigt system-weite Installation)
  programs.steam = {
    enable                       = true;
    remotePlay.openFirewall      = true;   # Ports für Remote Play öffnen
    dedicatedServer.openFirewall = true;   # Ports für Dedicated Server öffnen
  };

  # GameMode für bessere Performance
  programs.gamemode.enable = true;

  # Gaming-Pakete (User-Installation via Home-Manager)
  # Diese werden über home-manager.users.jean.home.packages bereitgestellt
  home-manager.users.jean.home.packages = with pkgs; [
    # Game Launcher
    heroic               # Epic Games, GOG, Amazon Games
    lutris-unwrapped     # Wine Gaming Platform
    qbittorrent
    protonvpn-gui
    # Tools
    mangohud             # FPS Overlay & Performance Monitoring
    protonup-qt          # Proton/Wine Version Manager
  ];
}
