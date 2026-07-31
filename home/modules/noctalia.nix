{ config, pkgs, lib, ... }:

let
  # ==========================================================================
  # Cheatsheet-Plugin: Quelle aus dem community-plugins Repo
  # ==========================================================================
  # Noctalia scannt `~/.local/share/noctalia/plugins/<dir>/plugin.toml` und
  # steigt dabei nur EINE Verzeichnisebene ab (PluginRegistry::scanDir). Das
  # Layout muss deshalb FLACH sein: plugins/keybind-cheatsheet/plugin.toml.
  # Ein verschachteltes plugins/kenn/keybind-cheatsheet/ würde NICHT gefunden.
  # Die Plugin-ID ("kenn/keybind-cheatsheet") kommt aus dem Manifest, nicht aus
  # dem Verzeichnisnamen — der Verzeichnisname ist frei wählbar.
  #
  # Im Repo liegt das Plugin flach im Wurzelverzeichnis unter
  # `keybind-cheatsheet/` (kein `plugins/`- und kein `kenn/`-Präfix).
  #
  # ##########################################################################
  # ##                                                                      ##
  # ##   ACHTUNG — HASH MUSS BEIM ERSTEN BUILD VON HAND GESETZT WERDEN      ##
  # ##                                                                      ##
  # ##   `hash` steht auf `lib.fakeHash` (Platzhalter aus lauter A's),      ##
  # ##   weil der echte Hash auf diesem Rechner nicht berechnet werden      ##
  # ##   konnte (kein Nix verfügbar).                                       ##
  # ##                                                                      ##
  # ##   Der ERSTE `nixos-rebuild switch` WIRD FEHLSCHLAGEN, mit:           ##
  # ##                                                                      ##
  # ##       error: hash mismatch in fixed-output derivation ...            ##
  # ##         specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA   ##
  # ##              got: sha256-<DER ECHTE WERT>                            ##
  # ##                                                                      ##
  # ##   Den Wert hinter `got:` KOPIEREN und unten bei `hash =` eintragen,  ##
  # ##   dann erneut bauen. Danach ist der Build reproduzierbar.            ##
  # ##                                                                      ##
  # ##########################################################################
  communityPlugins = pkgs.fetchFromGitHub {
    owner = "noctalia-dev";
    repo  = "community-plugins";
    rev   = "ee84a9b11e2553a065b63fcc506120b321588c5d";
    hash  = lib.fakeHash;
  };

  # Wallpaper: dieselbe Datei, die `stylix.image` in configuration.nix nutzt.
  # Bewusst als relativer Pfad statt über `config.stylix.image`, damit die
  # Auswertung nicht von der NixOS -> Home-Manager-Vererbung von Stylix abhängt.
  # Als echter Nix-Pfad (nicht `toString`), damit die Datei garantiert in den
  # Store kopiert wird und der eingetragene Pfad zur Laufzeit auch existiert.
  wallpaperPath = ../../assets/NixOS_Black_Sun.png;
in
{
  # ==========================================================================
  # Noctalia v5 (Wayland-Shell: Bar, Panels, OSD, Lockscreen, Notifications)
  # ==========================================================================
  # Ersetzt den kompletten bisherigen Stack aus Waybar, mako, wlogout,
  # swaylock-effects, fuzzel, swayidle und swww/waypaper. Noctalia stellt
  # `org.freedesktop.Notifications` und `org.kde.StatusNotifierWatcher` selbst
  # bereit — es darf deshalb kein zweiter Notification-Daemon oder Tray-Host
  # parallel laufen.
  programs.noctalia = {
    enable = true;

    # ------------------------------------------------------------------------
    # Start: bewusst KEIN systemd-Service
    # ------------------------------------------------------------------------
    # Upstream (PACKAGING.md) liefert selbst keine systemd-Unit; die niri-Doku
    # empfiehlt ausdrücklich `spawn-at-startup "noctalia"`. Die von den
    # Nix-Modulen erzeugte Unit hängt an `graphical-session.target` — ob niri
    # dieses Target beim Start von einer TTY überhaupt erreicht, ist NICHT
    # verifiziert. Der Compositor-Autostart ist damit der robustere Weg.
    # Die Zeile `spawn-at-startup "noctalia"` steht in home/niri-config.kdl.
    systemd.enable = false;

    # Führt `noctalia config validate` zur Build-Zeit aus. Bleibt bewusst an:
    # Schema-Fehler in `settings` fallen so beim Bauen auf und nicht erst
    # zur Laufzeit in einer kaputten Session.
    validateConfig = true;

    # ------------------------------------------------------------------------
    # settings -> ~/.config/noctalia/config.toml
    # ------------------------------------------------------------------------
    # Nur Abweichungen von den Defaults setzen. Alles Nicht-Gesetzte fällt auf
    # Noctalias eigene Defaults zurück (siehe example.toml des Projekts).
    settings = {

      # ── Shell ────────────────────────────────────────────────────────────
      shell = {
        # Muss explizit gesetzt werden: Stylix hat KEIN Noctalia-Target, das
        # Theming erreicht die Shell also nicht. Wert identisch zu
        # `stylix.fonts.monospace.name` in configuration.nix.
        font_family      = "JetBrainsMono Nerd Font";

        # Noctalia bringt einen eigenen Polkit-Agenten mit (Default: aus).
        # Er wird hier aktiviert, weil `security.polkit.enable = true` in
        # configuration.nix gesetzt ist. Dann darf aber KEIN zweiter Agent
        # (polkit-gnome, lxqt-policykit, ...) gestartet werden — sonst
        # konkurrieren zwei Agenten um dieselben Dialoge.
        polkit_agent     = true;

        # Kein anonymer Start-Ping nach außen.
        telemetry_enabled = false;

        # Hinweis: `offline_mode = true` würde jeglichen ausgehenden HTTP-
        # Verkehr blocken. Bewusst NICHT gesetzt, da sonst auch harmlose
        # Launcher-Funktionen (Wechselkurse) wegfallen; die relevanten
        # Netzwerkpfade (Templates, Community-Paletten, Plugin-Repos) sind
        # weiter unten ohnehin einzeln abgeschaltet.
      };

      # ── Theme ────────────────────────────────────────────────────────────
      theme = {
        # Dunkel, passend zu `stylix.polarity = "dark"` in configuration.nix.
        mode           = "dark";

        # Farben kommen aus einer eigenen Palette, nicht aus einem Built-in.
        source         = "custom";

        # Dateibasisname ohne ".json" unter ~/.config/noctalia/palettes/.
        # Wird in home/modules/theming.nix als `customPalettes.Stylix` erzeugt.
        custom_palette = "Stylix";

        templates = {
          # ────────────────────────────────────────────────────────────────
          # Template-Engine KOMPLETT aus — konkreter Konflikt mit Stylix:
          # Stylix schreibt App-Theme-Dateien zur BUILD-Zeit als read-only
          # Symlinks in den Nix-Store (z. B. ~/.config/kitty/...). Noctalias
          # Template-Engine würde exakt dieselben Dateien zur LAUFZEIT
          # überschreiben wollen. Das schlägt entweder fehl (Store ist
          # read-only) oder zerstört den deklarativen Zustand.
          # Stylix bleibt alleinige Quelle der Wahrheit für App-Theming.
          # ────────────────────────────────────────────────────────────────
          enable_builtin_templates   = false;
          builtin_ids                = [ ];
          enable_community_templates = false;
          community_ids              = [ ];
        };
      };

      # ── Bar ──────────────────────────────────────────────────────────────
      # WICHTIG: Der Tabellenname ist zugleich der Bar-Name und bestimmt den
      # Layer-Shell-Namespace: [bar.main] -> "noctalia-bar-main". Die
      # layer-rule in home/niri-config.kdl matcht auf genau diesen Namen.
      # Umbenennen bricht die Regel.
      bar.main = {
        position           = "top";

        # Entspricht der bisherigen Waybar-Höhe von 32 px.
        thickness          = 32;

        # Waybar-Fenster war transparent, die Module hatten eigene Pillen.
        # `capsule` bildet genau diesen Look nach; die Bar selbst bleibt
        # dezent (Wert entspricht `stylix.opacity.desktop = 0.85`).
        background_opacity = 0.85;
        capsule            = true;

        # Durchgehende Leiste über die volle Breite wie bisher, keine
        # freischwebende Insel (Noctalia-Default wäre margin_ends = 180).
        margin_ends        = 0;
        margin_edge        = 0;
        radius             = 0;

        # Platz für die Bar reservieren, damit Fenster nicht darunter laufen.
        reserve_space      = true;
        auto_hide          = false;

        # ────────────────────────────────────────────────────────────────
        # Widget-Anordnung, 1:1 aus der alten Waybar übernommen:
        #   links  : niri/workspaces        -> workspaces
        #   mitte  : clock                  -> clock
        #   rechts : pulseaudio             -> volume
        #            network                -> network
        #            bluetooth              -> bluetooth
        #            battery                -> battery
        #            power-profiles-daemon  -> power_profile
        #            custom/power (wlogout) -> session
        # Neu hinzu: tray (Waybar war vorher kein Tray-Host) sowie
        # notifications und control-center als Ersatz für mako bzw. für die
        # zentralen Umschalter.
        # ────────────────────────────────────────────────────────────────
        start  = [ "workspaces" ];
        center = [ "clock" ];
        end    = [
          "tray"
          "notifications"
          "volume"
          "network"
          "bluetooth"
          "battery"
          "power_profile"
          "control-center"
          "session"
        ];
      };

      # ── Notifications ────────────────────────────────────────────────────
      notification = {
        # Ersetzt mako. Darf nur an sein, solange kein zweiter Daemon läuft
        # (siehe Kommentar in home/modules/packages.nix).
        enable_daemon = true;
      };

      # ── OSD (Lautstärke / Helligkeit / Toggles) ──────────────────────────
      osd = {
        position = "top_right";
      };

      # ── Lockscreen ───────────────────────────────────────────────────────
      # Ersetzt swaylock-effects. Authentifizierung läuft über PAM.
      lockscreen = {
        enabled         = true;

        # Entspricht dem bisherigen swaylock `screenshots = true` +
        # `effect-blur`. Benötigt das Protokoll wlr-screencopy-unstable-v1.
        blurred_desktop = true;
        blur_intensity  = 0.5;
        tint_intensity  = 0.3;
      };

      # ── Idle ─────────────────────────────────────────────────────────────
      # Ersetzt swayidle. Konservativ: bewusst deaktiviert, damit der Rechner
      # nicht ungefragt sperrt oder den Bildschirm abschaltet. Die Timeouts
      # stehen bereits richtig, es fehlt nur `enabled = true`.
      # Der optionale Schlüssel `pre_action_fade_seconds` wird bewusst NICHT
      # gesetzt: Nix serialisiert einen Float wie 2.0 über builtins.toJSON als
      # Integer `2`, was die Schema-Prüfung beim Bauen zerlegen könnte. Da
      # beide Aktionen ohnehin deaktiviert sind, hätte er auch keinen Effekt.
      idle = {
        behavior = {
          lock = {
            timeout = 600;
            action  = "lock";
            enabled = false;
          };
          # Tabellenname enthält einen Bindestrich -> in Nix quoten.
          "screen-off" = {
            timeout = 660;
            action  = "screen_off";
            enabled = false;
          };
        };
      };

      # ── Wallpaper ────────────────────────────────────────────────────────
      # Ersetzt swww + waypaper. Zeigt dasselbe Bild wie `stylix.image`,
      # damit der Desktop nach der Migration unverändert aussieht.
      wallpaper = {
        enabled   = true;
        fill_mode = "crop";

        default = {
          path = wallpaperPath;
        };
      };

      # ── Audio ────────────────────────────────────────────────────────────
      audio = {
        # Kein Boost über 100 % — schützt vor versehentlichem Übersteuern.
        enable_overdrive = false;

        # Keine UI-Klickgeräusche.
        enable_sounds    = false;
      };

      # ── Helligkeit ───────────────────────────────────────────────────────
      brightness = {
        # Laptop mit internem Backlight: der sysfs-Pfad reicht, ddcutil
        # (für externe Monitore per DDC/CI) wird nicht gebraucht.
        enable_ddcutil = false;
      };

      # ── Control Center ───────────────────────────────────────────────────
      control_center = {
        # Bis zu sechs Schnellschalter rechts im Dashboard.
        shortcuts = [
          { type = "wifi"; }
          { type = "bluetooth"; }
          { type = "nightlight"; }
          { type = "notification"; }
          { type = "wallpaper"; }
          { type = "session"; }
        ];
      };

      # ── Batterie ─────────────────────────────────────────────────────────
      # TODO/UNVERIFIED: Laut Quell-Schema (config_sections.cpp) existiert eine
      # Sektion [battery], sie fehlt aber komplett in example.toml und in der
      # Recherche sind KEINE Schlüsselnamen belegt. Es wird deshalb bewusst
      # nichts gesetzt (Defaults gelten). Erst nach `noctalia config export full`
      # auf dem Zielsystem ergänzen — Raten würde `validateConfig` brechen.

      # ── Plugins ──────────────────────────────────────────────────────────
      plugins = {
        # Opt-in-Registry: ein Plugin ist nur aktiv, wenn seine Manifest-ID
        # hier steht. Der Wert ist die vollständige, namespaced ID aus
        # plugin.toml — NICHT der Verzeichnisname.
        enabled     = [ "kenn/keybind-cheatsheet" ];

        # Kein automatisches Nachladen aus dem Netz; die Version ist über
        # `fetchFromGitHub` oben auf einen Commit gepinnt.
        auto_update = false;

        # Die beiden Default-Quellen (official + community) werden explizit
        # abgeschaltet, damit Noctalia zur Laufzeit keine Git-Repos klont
        # oder aktualisiert. Das lokale Datenverzeichnis
        # (~/.local/share/noctalia/plugins) wird davon unabhängig IMMER
        # gescannt — dort landet unser Nix-verwaltetes Plugin.
        source = [
          {
            name     = "official";
            kind     = "git";
            location = "https://github.com/noctalia-dev/official-plugins";
            enabled  = false;
          }
          {
            name     = "community";
            kind     = "git";
            location = "https://github.com/noctalia-dev/community-plugins";
            enabled  = false;
          }
        ];
      };

      # Plugin-eigene Einstellungen. Die Schlüssel werden gegen das Manifest
      # des Plugins validiert; `compositor` und `niri_config` sind dort als
      # [[setting]] deklariert.
      plugin_settings."kenn/keybind-cheatsheet" = {
        # Nicht raten lassen, wir wissen dass niri läuft.
        compositor  = "niri";
        niri_config = "~/.config/niri/config.kdl";
      };
    };
  };

  # ==========================================================================
  # Cheatsheet-Plugin ablegen
  # ==========================================================================
  # Zielpfad ist das DATEN-Verzeichnis (`xdg.dataFile`), nicht das Config-
  # Verzeichnis: FileUtils::dataDir() -> $XDG_DATA_HOME/noctalia bzw.
  # ~/.local/share/noctalia, darunter `plugins/`.
  # Ein read-only Store-Symlink ist ausdrücklich in Ordnung — schreibbarer
  # Zustand des Plugins (preferences.json, bindings-cache.json) landet
  # separat unter ~/.local/state/noctalia/plugins/data/kenn/keybind-cheatsheet/.
  xdg.dataFile."noctalia/plugins/keybind-cheatsheet".source =
    "${communityPlugins}/keybind-cheatsheet";

  # Optional, bewusst nicht aktiviert: Das Plugin bringt auch ein Bar-Widget
  # mit. Es ließe sich so einbinden —
  #   settings."widget"."cheatsheet_btn".type = "kenn/keybind-cheatsheet:keybinds";
  #   und "cheatsheet_btn" zusätzlich in bar.main.end aufnehmen.
  # Weggelassen, weil das Panel bereits per Tastenkombination erreichbar ist
  # (`noctalia msg panel-toggle kenn/keybind-cheatsheet:cheatsheet`) und ein
  # ins Leere zeigender Widget-Name die Build-Zeit-Validierung brechen würde,
  # falls das Plugin einmal nicht geladen wird.
}
