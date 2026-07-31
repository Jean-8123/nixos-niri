{ config, pkgs, lib, ... }:

{
  # ==========================================================================
  # Terminal: Kitty
  # ==========================================================================
  # Nur aktivieren, keine eigenen Einstellungen: Schrift, Schriftgröße,
  # Farbschema und Transparenz (stylix.opacity.terminal = 0.9) kommen
  # vollständig aus dem Stylix-Kitty-Target. Eigene Werte hier würden mit
  # Stylix kollidieren.
  programs.kitty.enable = true;
}
