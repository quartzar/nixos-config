# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use flakes and nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  #console.keyMap = "gb";
  console.useXkbConfig = true;
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };


    # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.quartzar = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "quartzar" = import ./home.nix;
    };
    backupFileExtension = "backup";
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Hyprland
  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
#  programs.hyprland = {
#    enable = true;
#    xwayland.enable = true;
#    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
#  };


  # Required Services
  services.dbus.enable = true;
#   services.dbus.packages = [ pkgs.gcr ];
  services.gvfs.enable = true;

  # Keyring
#   services.gnome.gnome-keyring = {
#     enable = true;
#   };
#   security.pam.services.sddm.kwallet.enable = true;
#   services.gnome.gnome-keyring.enable = true;
#   security.pam.services = {
#     login.enableGnomeKeyring = true;
#     sddm.enableGnomeKeyring = true;
#     gdm-password.enableGnomeKeyring = true;
#   };


  # Login and keyring
  # Enable greetd with regreet
#   services.greetd = {
#     enable = true;
#     package = pkgs.greetd;
#   };
#
#   programs.regreet = {
#     enable = true;
#     settings = {
# #       background = {
# #         path = "/path/to/your/wallpaper.png";  # Optional
# #         fit = "Cover";  # Optional
# #       };
#       GTK = {
#         application_prefer_dark_theme = true;
# #         theme_name = "Adwaita-dark";
# #         icon_theme_name = "Papirus-Dark";
#       };
#       commands = {
#         reboot = ["systemctl" "reboot"];
#         poweroff = ["systemctl" "poweroff"];
#       };
#     };
#   };

  # GNOME Keyring configuration
#   services.gnome.gnome-keyring.enable = true;
#   security.pam.services.greetd.enableGnomeKeyring = true;
#   security.pam.services.gdm.enableGnomeKeyring = true;
#   security.pam.services.gdm-password.enableGnomeKeyring = true;

  # TAKEN FROM: https://github.com/iancleary/desktop-config/blob/0b918f4c4376a0e28f5e5b2598a9d585f6768478/modules/desktop/hyprland/default.nix#L59-L83
  # https://nixos.wiki/wiki/Greetd
  # tweaked for Hyprland
  # ...
  # launches swaylock with exec-once in home/hyprland/hyprland.conf
  # ...
  # single user and single window manager
  # my goal here is auto-login with authentication
  # so I can declare my user and environment (Hyprland) in this config
  # my goal is NOT to allow user selection or environment selection at the the login screen
  # (which a login manager provides beyond just the authentication check)
  # so I don't need a login manager
  # I just launch Hyprland as iancleary automatically, which starts swaylock (to authenticate)
  # I thought I needed a greeter, but I really don't
  # ...
#   services.greetd = {
#     enable = true;
#     settings = rec {
#       initial_session = {
#         command = "${pkgs.hyprland}/bin/Hyprland";
#         user = "quartzar";
#       };
#       default_session = initial_session;
#     };
#   };

  # Display Manager
  services.xserver = {
    enable = true;
    xkb.layout = "gb";
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # GNOME Keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services = {
    sddm.enableGnomeKeyring = true;
    login.enableGnomeKeyring = true;
  };

#   services.displayManager.sddm = {
#     enable = true;
#     wayland.enable = true;
#   };

  # Flatpak
  services.flatpak.enable = true;

  # Plex
#   services.plex = {
#     enable = true;
#     openFirewall = true;
#   };

  # Portal (?)
  xdg.portal = {
    enable = true;
    extraPortals =
      [
        pkgs.xdg-desktop-portal-gtk
      ];
    config.common.default = "*";
    xdgOpenUsePortal = true;
  };


  # NVIDIA-specific kernel parameters
#  boot.kernelParams =
#    [
#      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
#    ];
  
  # Wayland Configuration
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
#     XDG_CURRENT_DESKTOP = "Hyprland";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
#     XDG_STATE_HOME  = "$HOME/.local/state";
    XDG_RUNTIME_DIR = "/run/user/$UID";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
#     SSH_AUTH_LOCK = "/run/user/1000/keyring/ssh";
#     XDG_DATA_DIRS = "/var/lib/flatpak/exports/share:/home/quartzar/.local/share/flatpak/exports/share:$XDG_DATA_DIRS";
    SSH_AUTH_SOCK = "/run/user/$UID/keyring/ssh";
    GNOME_KEYRING_CONTROL = "/run/user/$UID/keyring";
  };


  # Enable unfree packages (required for NVIDIA)
  nixpkgs.config.allowUnfree = true;

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  
  # Load NVIDIA driver for Xorg/Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  # NVIDIA configuration
  hardware.nvidia = {
    # Modesetting is required
    modesetting.enable = true;

    # Power management
    powerManagement.enable = true;
    # Finegrained only works on Turing and newer
    powerManagement.finegrained = false;

    # Don't use the open source kernel modules
    open = false;

    # Enable the settings menu
    nvidiaSettings = true;

    # Driver version (production is currently (29/11/24) on v550
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    hyprland-protocols
    hyprpaper  # wallpaper utility
    hyprpicker   # colour picker
    wl-clipboard  # allows copying to clipboard
    playerctl  # media player control
    brightnessctl  # brightness control
    wireplumber
    pipewire
    pavucontrol
    qpwgraph
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    (wrapFirefox (firefox-unwrapped.override { pipewireSupport = true;}) {})
    tree
    kitty
    networkmanager
    git
    neofetch
    curl
    swww           # wallpaper
    waypaper
    dunst          # notifications
    rofi-wayland   # application launcher
    eww            # widgets
    waybar
    wlogout
    swaylock-effects
    swayidle
    home-manager
    kdePackages.dolphin        # my beloved
    kdePackages.dolphin-plugins
    kdePackages.kate
    kdePackages.ktexteditor
    kdePackages.kauth
    kdePackages.plasma-systemmonitor
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    nvidia-vaapi-driver
    qt5.qtwayland
    qt6.qmake
    qt6.qtwayland
    adwaita-qt
    adwaita-qt6
    polkit
    polkit-kde-agent
    libsForQt5.polkit-kde-agent
    htop
    zsh-autocomplete
    zsh-autosuggestions
    zsh-syntax-highlighting
    spotify
#     vscode.fhs
    papirus-icon-theme  # like my beloved gruvbox icons, https://www.pling.com/p/1166289/
    (discord.override { withVencord = true; })
    seahorse  # GUI for managing passwords
    libsecret  # secret service API
    flatpak
    vlc
    plex-desktop
    nwg-look
    openssl
    cacert
  ];
  

  # Ensure polkit service is enabled
 # security.polkit = {
 #   enable = true;
 #   extraConfig = ''
 #     polkit.addRule(function(action, subject) {
 #       if (action.id == "org.kde.kate.file_save" ||
 #           action.id == "org.kde.kate.file_save_as") {
 #         return polkit.Result.YES;
 #       }
 #     });
 #   '';
 # };

#  systemd.services.polkit = {
#    enable = true;
#    wantedBy = [ "multi-user.target" ];
#    restartIfChanged = true;
#  };

  security.polkit.enable = true;
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  # Required for KDE apps, like Kate, when writing privileged files
  systemd.user.services.polkit-kde-authentication-agent-1 = {
    enable = true;
    description = "polkit-kde-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" "dbus.service" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };



  # FONTS!
  fonts.enableDefaultPackages = true;
  fonts.fontconfig = {
    defaultFonts = {
      sansSerif = [ "Rubik" ];
      monospace = [ "JetBrainsMonoNerdFontMono" ];
    };
  };
  fonts.packages = with pkgs; [
    rubik
    # (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) old method
    nerd-fonts.jetbrains-mono
  ];

  # SHELL & ZSH
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;




  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  


  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = false;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?


}

