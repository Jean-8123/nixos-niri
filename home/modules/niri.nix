{ config, pkgs, lib, ... }:

{
  # ==========================================================================
  # Niri Window Manager (Compositor-Konfiguration)
  # ==========================================================================
  # Die KDL-Datei wird bewusst unverändert durchgereicht statt aus Nix
  # generiert: niri-Konfiguration ist stark verschachtelt und die
  # Original-Syntax bleibt so kopierbar und mit der Upstream-Doku vergleichbar.
  #
  # Inhaltlich relevant für Noctalia sind dort drei Dinge:
  #   - `spawn-at-startup "noctalia"` (Autostart, statt systemd-Unit)
  #   - die layer-rule auf den Namespace "noctalia-bar-main"
  #   - die Keybinds auf `noctalia msg ...`
  xdg.configFile."niri/config.kdl".source = ../niri-config.kdl;
}
