{ config, pkgs, lib, ... }:

let
  # ==========================================================================
  # Farbquelle: Stylix
  # ==========================================================================
  # Grundsatzentscheidung: Stylix bleibt die EINZIGE Quelle der Wahrheit für
  # Farben im gesamten System. Noctalia bringt eine eigene Theming-Maschinerie
  # mit (Built-in-Paletten, Community-Paletten, wallpaper-basiertes matugen und
  # eine Template-Engine, die App-Configs zur Laufzeit schreibt). Diese Engine
  # ist in home/modules/noctalia.nix vollständig abgeschaltet.
  #
  # Diese Datei ist damit der EINZIGE Ort, an dem beide Systeme aufeinander
  # treffen: die base16-Farben aus Stylix werden zur Eval-Zeit in eine
  # Noctalia-Custom-Palette übersetzt. Wird das base16-Schema in
  # configuration.nix getauscht, wandert die Änderung automatisch mit.
  #
  # `config.lib.stylix.colors` wird von Stylix' base16.nix erzeugt und ist laut
  # Stylix-Doku der vorgesehene Weg, Farben an nicht unterstützte Targets
  # weiterzureichen. `withHashtag` liefert die Werte inklusive führendem "#",
  # was Noctalia für Hex-Farben erwartet (#RGB / #RGBA / #RRGGBB / #RRGGBBAA).
  #
  # Verfügbar ist das hier, weil Stylix als NixOS-Modul geladen ist und sich
  # bei Home-Manager-als-NixOS-Modul automatisch in die User-Konfiguration
  # vererbt (stylix.homeManagerIntegration.autoImport, Default an).
  c = config.lib.stylix.colors.withHashtag;
in
{
  # ==========================================================================
  # Noctalia-Palette aus Stylix ableiten
  # ==========================================================================
  # Der Attributname wird zum Dateinamen:
  #   customPalettes.Stylix -> ~/.config/noctalia/palettes/Stylix.json
  # und muss exakt dem `[theme] custom_palette = "Stylix"` in noctalia.nix
  # entsprechen. Bei fehlender oder ungültiger Datei fällt Noctalia stillschweigend
  # auf die eingebaute "Noctalia"-Palette zurück — der Fehler wäre also nur
  # optisch sichtbar, nicht als Build-Fehler.
  programs.noctalia.customPalettes.Stylix = {

    # Ein "light"-Block wird bewusst weggelassen: laut Doku nutzt Noctalia die
    # dark-Variante dann für beide Modi. Passend zu `stylix.polarity = "dark"`
    # und `[theme] mode = "dark"`.
    dark = {
      # ── Die 16 Farbrollen ──────────────────────────────────────────────
      # Alle 16 werden explizit gesetzt. Ob Noctalia fehlende Rollen mit
      # Defaults auffüllt oder die Palette komplett verwirft, ist NICHT
      # verifiziert — die Doku zeigt durchgängig alle 16, also alle 16.
      #
      # Zuordnung base16 -> Rolle (Catppuccin Mocha):
      #   base0D blue    -> Primärakzent (aktive Zustände, Links, Buttons)
      #   base0E mauve   -> Sekundärakzent
      #   base0C teal    -> Tertiärakzent
      #   base08 red     -> Fehler / destruktive Aktionen
      #   base00 base    -> Haupt-Hintergrund
      #   base05 text    -> Haupt-Vordergrund
      #   base02 surface0 -> Karten / Panels / Hover-Fläche
      #   base04 surface2 -> gedämpfter Text auf Varianten-Flächen
      #   base03 surface1 -> Rahmen und Trenner
      mPrimary           = c.base0D;
      mOnPrimary         = c.base00;
      mSecondary         = c.base0E;
      mOnSecondary       = c.base00;
      mTertiary          = c.base0C;
      mOnTertiary        = c.base00;
      mError             = c.base08;
      mOnError           = c.base00;
      mSurface           = c.base00;
      mOnSurface         = c.base05;
      mSurfaceVariant    = c.base02;
      mOnSurfaceVariant  = c.base04;
      mOutline           = c.base03;

      # Schatten bleibt echtes Schwarz statt einer Schemafarbe: ein
      # aufgehellter Schatten wirkt in dunklen Themes wie ein Halo.
      mShadow            = "#000000";

      mHover             = c.base02;
      mOnHover           = c.base05;

      # ── Terminal-Farben ────────────────────────────────────────────────
      # Optionaler Block; folgt der Standard-Zuordnung base16 -> ANSI.
      # Hinweis: Kitty selbst wird weiterhin direkt von Stylix eingefärbt.
      # Dieser Block existiert für Noctalia-interne Terminal-Darstellungen
      # und für konsistente Farbvorschauen in der Shell-UI.
      terminal = {
        background  = c.base00;
        foreground  = c.base05;
        cursor      = c.base05;
        cursorText  = c.base00;

        # Abweichung von den Doku-Beispielwerten (dort invertiert
        # Vordergrund/Hintergrund): base02/base05 ist die übliche
        # base16-Konvention für Auswahl und liest sich deutlich ruhiger.
        selectionBg = c.base02;
        selectionFg = c.base05;

        normal = {
          black   = c.base00;
          red     = c.base08;
          green   = c.base0B;
          yellow  = c.base0A;
          blue    = c.base0D;
          magenta = c.base0E;
          cyan    = c.base0C;
          white   = c.base05;
        };

        bright = {
          black   = c.base03;
          red     = c.base08;
          green   = c.base0B;
          yellow  = c.base0A;
          blue    = c.base0D;
          magenta = c.base0E;
          cyan    = c.base0C;
          white   = c.base07;
        };
      };
    };
  };
}
