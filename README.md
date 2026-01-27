# NixOS Konfiguration mit Niri

Eine deklarative NixOS-Konfiguration mit dem Niri Wayland Compositor, Stylix Theming und Home-Manager.

## Verzeichnisstruktur

```
nixos-niri/
├── flake.nix              # Flake-Definition mit Inputs und System-Konfiguration
├── configuration.nix      # Hauptkonfiguration (System-weit)
├── hosts/
│   └── LT-hardware.nix    # Hardware-spezifische Konfiguration (Laptop)
├── modules/
│   └── nvidia.nix         # NVIDIA Grafiktreiber Modul
├── home/
│   ├── home.nix           # Home-Manager Konfiguration (User-spezifisch)
│   └── niri-config.kdl    # Niri Window Manager Konfiguration
└── assets/
    └── *.png              # Wallpaper und Bilder
```

## Dateien im Detail

### `flake.nix`

Die Flake-Definition verwaltet alle externen Abhängigkeiten:

| Input | Beschreibung |
|-------|-------------|
| `nixpkgs` | NixOS Unstable Packages |
| `stylix` | System-weites Theming |
| `home-manager` | User-spezifische Konfiguration |

**Host-Konfiguration:** `LT-nixos` (x86_64-linux)

---

### `configuration.nix`

Die zentrale System-Konfiguration. Hier wird alles definiert, was **root-Rechte** braucht oder **system-weit** gilt.

| Bereich | Einstellung |
|---------|-------------|
| **Boot** | systemd-boot, EFI |
| **Netzwerk** | NetworkManager, Firewall deaktiviert |
| **SSH** | OpenSSH aktiviert, Root-Login verboten, fail2ban |
| **Zeitzone** | Europe/Berlin |
| **Locale** | en_US.UTF-8 (System), de_DE.UTF-8 (Formate) |
| **Tastatur** | Deutsches Layout (de) |
| **Benutzer** | `jean` (wheel, networkmanager) |
| **Nix** | Flakes und nix-command aktiviert, unfree erlaubt |

**System-Programme:**
- `niri` - Wayland Tiling Compositor
- `steam` - Gaming Platform
- `git`, `neovim`, `xwayland-satellite`

**Stylix Theming:**
- Theme: Catppuccin Mocha
- Font: JetBrainsMono Nerd Font
- Cursor: Catppuccin Mocha Dark
- Wallpaper: `assets/NixOS_Black_Sun.png`

---

### `hosts/LT-hardware.nix`

Auto-generierte Hardware-Konfiguration (via `nixos-generate-config`). **Nicht manuell bearbeiten!**

- Kernel-Module: `xhci_pci`, `ahci`, `nvme`, `kvm-intel`
- Dateisysteme: `/` (ext4), `/boot` (vfat)
- Swap-Partition aktiviert
- Intel CPU Microcode Updates

---

### `modules/nvidia.nix`

NVIDIA Grafiktreiber-Konfiguration:

| Option | Wert | Beschreibung |
|--------|------|-------------|
| `videoDrivers` | nvidia | Proprietärer NVIDIA Treiber |
| `modesetting` | true | Kernel Mode Setting |
| `powerManagement` | true | Stromsparen aktiviert |
| `open` | false | Proprietär (nicht open-source) |
| `nvidiaSettings` | true | nvidia-settings GUI |

---

### `home/home.nix`

Home-Manager Konfiguration für User `jean`. Hier wird alles definiert, was **keine root-Rechte** braucht.

**Session-Variablen:**
```nix
NIXOS_OZONE_WL = "1"    # Wayland für Electron Apps
GTK_THEME = "Adwaita:dark"
TERMINAL = "kitty"
```

**Installierte Pakete:**

| Kategorie | Pakete |
|-----------|--------|
| **Browser** | Brave (Wayland) |
| **Terminal** | kitty, alacritty |
| **CLI Tools** | fastfetch, btop, ripgrep, fd, lazygit, unzip |
| **Wayland** | swaylock, swayidle, swww, waypaper, wlogout, mako, udiskie |
| **Entwicklung** | nodejs, gcc |
| **Apps** | localsend, pavucontrol, networkmanagerapplet, qbittorrent, protonvpn-gui, krita, aseprite |
| **Gaming** | heroic, lutris |

**Konfigurierte Programme:**

- **Kitty** - GPU-beschleunigtes Terminal
- **Waybar** - Status-Leiste mit Workspaces, Uhr, Batterie, Netzwerk, Audio, Power
- **Fuzzel** - Wayland App-Launcher

---

### `home/niri-config.kdl`

Niri Window Manager Konfiguration (KDL Format).

**Input:**
- Touchpad: Tap-to-Click, Natural Scroll
- Focus follows Mouse

**Layout:**
- Gaps: 10px
- Default Column Width: 50%
- Preset Widths: 33%, 50%, 66%
- Focus Ring: 2px, blau (#7fc8ff)

**Startup-Programme:**
```
waybar, xwayland-satellite, swww-daemon, mako
```

**Wichtige Keybindings:**

| Tastenkombination | Aktion |
|-------------------|--------|
| `Mod+T` | Terminal (Kitty) |
| `Mod+Space` | App-Launcher (Fuzzel) |
| `Mod+Q` | Fenster schließen |
| `Mod+F` | Maximieren |
| `Mod+Shift+F` | Fullscreen |
| `Mod+1-9` | Workspace wechseln |
| `Mod+H/J/K/L` | Fokus ändern (vim-style) |
| `Mod+Ctrl+H/J/K/L` | Fenster verschieben |
| `Mod+Shift+E` | Niri beenden |
| `Super+Alt+L` | Bildschirm sperren |
| `Super+Shift+B` | Browser öffnen |
| `Print` | Screenshot |

**Window Rules:**
- Kitty: 90% Transparenz
- Brave: 95% Transparenz
- Inaktive Fenster: 85% Transparenz
- Picture-in-Picture: Floating

---

## Verwendung

### System bauen und aktivieren

```bash
# Beim ersten Mal oder nach Änderungen an flake.nix
sudo nixos-rebuild switch --flake .#LT-nixos

# Nur Konfiguration testen (ohne zu aktivieren)
sudo nixos-rebuild test --flake .#LT-nixos

# Flake aktualisieren
nix flake update
```

### Neues Modul hinzufügen

1. Datei in `modules/` erstellen
2. In `flake.nix` unter `modules` importieren

### Neues Paket hinzufügen

- **System-weit:** In `configuration.nix` unter `environment.systemPackages`
- **User-spezifisch:** In `home/home.nix` unter `home.packages`

---

## Theming

Das Theming wird komplett über **Stylix** gesteuert. Änderungen in `configuration.nix`:

```nix
stylix = {
  base16Scheme = "${pkgs.base16-schemes}/share/themes/THEME_NAME.yaml";
  image = ./assets/WALLPAPER.png;
  polarity = "dark";  # oder "light"
};
```

Verfügbare Themes: [base16-schemes](https://github.com/tinted-theming/base16-schemes)
