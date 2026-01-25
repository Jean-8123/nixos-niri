{ config, pkgs, ... }:

{
  # Option 1: Externe config-Datei
  xdg.configFile."niri/config.kdl".source = ./niri-config.kdl;

  # Option 2: Inline-Konfiguration
  #xdg.configFile."niri/config.kdl".text = ''
  #  // Deine niri Konfiguration hier
  #  // Deine niri Konfiguration hier
  #  // Deine niri Konfiguration hier
#
 # '';
}

