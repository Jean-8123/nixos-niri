{ config, lib, pkgs, ... }:

{
  # ==========================================================================
  # Boot
  # ==========================================================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ==========================================================================
  # Netzwerk
  # ==========================================================================
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  # ==========================================================================
  # SSH & Sicherheit
  # ==========================================================================
  services.openssh.enable = true;
  # Hinweis: hiess frueher `services.openssh.permitRootLogin`. Die Option wurde
  # in NixOS 23.05 nach `settings.PermitRootLogin` verschoben; der alte Alias
  # faellt beim anstehenden `nix flake update` weg und wuerde den Build brechen.
  services.openssh.settings.PermitRootLogin = "no";
  services.fail2ban.enable = true;

  # ==========================================================================
  # Zeit & Sprache
  # ==========================================================================
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT    = "de_DE.UTF-8";
    LC_MONETARY       = "de_DE.UTF-8";
    LC_NAME           = "de_DE.UTF-8";
    LC_NUMERIC        = "de_DE.UTF-8";
    LC_PAPER          = "de_DE.UTF-8";
    LC_TELEPHONE      = "de_DE.UTF-8";
    LC_TIME           = "de_DE.UTF-8";
  };

  # ==========================================================================
  # Tastatur & Eingabe
  # ==========================================================================
  services.xserver.xkb = {
    layout  = "de";
    variant = "";
  };
  console.keyMap = "de";

  # ==========================================================================
  # Power Management
  # ==========================================================================
  services.power-profiles-daemon.enable = true;

  # ==========================================================================
  # Audio (PipeWire)
  # ==========================================================================
  # Harte Laufzeit-Anforderung von Noctalia: Lautstärke-OSD, Privacy-Indikator
  # und Spektrum-Widget brauchen einen laufenden PipeWire-Daemon — die
  # Bibliotheken allein genügen nicht. WirePlumber muss mindestens 0.5 sein
  # (0.4 reicht ausdrücklich nicht); nixos-unstable liefert 0.5.x.
  security.rtkit.enable = true;   # Echtzeit-Priorität für PipeWire (verhindert Aussetzer)

  services.pipewire = {
    enable             = true;
    alsa.enable        = true;
    alsa.support32Bit  = true;
    pulse.enable       = true;
    wireplumber.enable = true;
  };

  # ==========================================================================
  # Bluetooth
  # ==========================================================================
  hardware.bluetooth.enable      = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable        = true;

  # ==========================================================================
  # Benutzer
  # ==========================================================================
  users.users.jean = {
    isNormalUser = true;
    description  = "Jean";
    extraGroups  = [ "networkmanager" "wheel" ];
  };

  # ==========================================================================
  # Nix Einstellungen
  # ==========================================================================
  nixpkgs.config.allowUnfree = true;

  # `extra-*` statt `substituters`/`trusted-public-keys`, damit cache.nixos.org
  # als Default erhalten bleibt. Ohne den Noctalia-Cache wird das native
  # meson/C++-Shell lokal gebaut (~20 Minuten).
  nix.settings = {
    experimental-features     = [ "nix-command" "flakes" ];
    extra-substituters        = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  # ==========================================================================
  # System-Programme
  # ==========================================================================
  programs.niri.enable = true;
  services.fwupd.enable = true;

  environment.systemPackages = with pkgs; [
    git
    neovim
    xwayland-satellite
  ];

  environment.variables = {
    EDITOR      = "nvim";
    SUDO_EDITOR = "nvim";
  };

  # ==========================================================================
  # Noctalia v5 (Laufzeit-Anforderungen auf System-Ebene)
  # ==========================================================================
  # Die Shell selbst wird über das Home-Manager-Modul `programs.noctalia`
  # installiert. Hier stehen nur die Dienste, die Noctalia auf System-Ebene
  # braucht und die das HM-Modul nicht setzen kann.

  # Sperrbildschirm: Noctalia authentifiziert per PAM über den Dienst `login`,
  # den NixOS ohnehin anlegt. Ein eigener `security.pam.services.noctalia`-
  # Eintrag ist deshalb nicht nötig — und laut Recherche ist nicht belegt,
  # dass Noctalia überhaupt zuerst nach einem solchen sucht.

  # Noctalia bringt einen eigenen, optionalen polkit-Agenten mit. Der Agent
  # selbst wird in Noctalias TOML über `[shell] polkit_agent` (Default: aus)
  # geschaltet; polkit muss dafür auf System-Ebene laufen. Kein zweiter
  # Agent (z.B. polkit-gnome) — sonst konkurrieren beide um die Dialoge.
  security.polkit.enable = true;

  # Ohne UPower erscheint das Batterie-Widget in der Bar überhaupt nicht.
  services.upower.enable = true;

  # Secret-Service-Provider: Noctalia braucht ihn für die verschlüsselte
  # Clipboard-History und die Kalender-Zugangsdaten. `libsecret` ist nur die
  # Client-Bibliothek — ohne Session-Provider können keine Secrets persistiert
  # werden. Der Daemon wird per D-Bus aktiviert.
  services.gnome.gnome-keyring.enable = true;

  # Es gibt hier keinen Display-Manager (Login per TTY, niri startet danach),
  # deshalb hängt der Keyring-Unlock am PAM-Dienst `login`. Sollte später ein
  # greetd/Display-Manager dazukommen, muss das Flag dort ebenfalls gesetzt
  # werden, sonst bleibt der Keyring nach dem Login gesperrt.
  security.pam.services.login.enableGnomeKeyring = true;

  # Wird bereits von ./modules/nvidia.nix gesetzt (in beiden Hosts aktiv).
  # Als mkDefault redundant abgesichert, falls nvidia.nix mal wegfällt —
  # das obere NixOS-Modul von Noctalia würde es sonst auch nicht setzen, da
  # wir nur das Home-Manager-Modul verwenden.
  hardware.graphics.enable = lib.mkDefault true;

  # Bewusst NICHT gesetzt: mako/dunst/swaync oder ein weiterer
  # StatusNotifier-Host. Noctalia beansprucht selbst
  # `org.freedesktop.Notifications` und `org.kde.StatusNotifierWatcher`.

  # ==========================================================================
  # Fonts
  # ==========================================================================
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # ==========================================================================
  # Stylix (Theming)
  # ==========================================================================
  stylix = {
    enable       = true;
    image        = ./assets/NixOS_Black_Sun.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity     = "dark";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name    = "JetBrainsMono Nerd Font";
      };
      sizes.terminal = 12;
    };

    # `desktop` betraf früher vor allem Waybar. Waybar ist raus — Noctalia
    # regelt seine Transparenz selbst in ~/.config/noctalia/config.toml.
    # Der Wert wirkt daher nur noch auf die übrigen Stylix-Desktop-Targets.
    opacity = {
      terminal     = 0.9;   # Terminals (Alacritty, Kitty, Foot, etc.)
      applications = 0.95;  # Normale Anwendungen (z.B. Brave)
      desktop      = 0.85;  # Restliche Stylix-Desktop-Targets
      popups       = 1.0;   # Popups/Tooltips
    };

    cursor = {
      name    = "catppuccin-mocha-dark-cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size    = 16;
    };
  };

  system.stateVersion = "25.11";
}

