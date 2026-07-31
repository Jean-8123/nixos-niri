{ config, pkgs, lib, ... }:

{
  # ==========================================================================
  # File Manager: Yazi (TUI) + Nautilus (GUI)
  # ==========================================================================
  # Yazi: moderner TUI File Manager in Rust mit Bildvorschau via Kitty-Protokoll.
  # Nautilus: GTK File Manager fuer Drag & Drop und Netzlaufwerke.
  # ==========================================================================

  # --------------------------------------------------------------------------
  # Yazi — TUI File Manager
  # --------------------------------------------------------------------------
  # `programs.yazi` aktiviert Yazi und integriert es optional in die Shell.
  # Kein eigenes Theming noetig: Stylix hat kein Yazi-Target, aber Yazi
  # liest Farben aus dem Terminal (Kitty/Stylix), was gut genug ist.
  programs.yazi = {
    enable = true;

    # Aktiviert `y`-Shell-Funktion: wechselt beim Beenden von Yazi ins
    # aktuelle Verzeichnis (cwd-integration). Funktioniert mit bash/zsh/fish.
    enableBashIntegration  = true;
    enableZshIntegration   = true;
    enableFishIntegration  = true;

    settings = {
      manager = {
        # Drei Spalten: Eltern | Aktuell | Vorschau
        ratio        = [ 1 3 4 ];
        sort_by      = "natural";
        sort_dir_first = true;
        show_hidden  = false;
        show_symlink = true;
      };

      preview = {
        # Kitty-Protokoll fuer native Bildvorschau im Terminal
        image_protocol = "kitty";
        max_width      = 600;
        max_height     = 900;
      };
    };
  };

  # --------------------------------------------------------------------------
  # Nautilus — GUI File Manager
  # --------------------------------------------------------------------------
  # Nautilus benoetigt gvfs fuer Muelleimer, Netzlaufwerke und MTP (Handys).
  # xdg-desktop-portal-gnome ist bereits in packages.nix vorhanden.
  home.packages = with pkgs; [
    nautilus
    gvfs          # Virtuelle Dateisysteme: Papierkorb, SMB, MTP, SFTP, ...
  ];

  # --------------------------------------------------------------------------
  # XDG MIME-Zuordnungen
  # --------------------------------------------------------------------------
  # Nautilus als Standard-Dateimanager fuer `xdg-open` und Portal-Anfragen.
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
    };
  };
}
