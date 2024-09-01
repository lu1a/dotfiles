{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fi_FI.UTF-8";
    LC_IDENTIFICATION = "fi_FI.UTF-8";
    LC_MEASUREMENT = "fi_FI.UTF-8";
    LC_MONETARY = "fi_FI.UTF-8";
    LC_NAME = "fi_FI.UTF-8";
    LC_NUMERIC = "fi_FI.UTF-8";
    LC_PAPER = "fi_FI.UTF-8";
    LC_TELEPHONE = "fi_FI.UTF-8";
    LC_TIME = "fi_FI.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  # programs.hyprland.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fi";
    variant = "mac";
  };

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lewis = {
    isNormalUser = true;
    description = "lewis";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    neovim
    curl
    git
    gh
    tmux
    neofetch
    cowsay
    unzip
    mosh
    ddclient
    nginx
    tor
    monero-cli
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services.openssh.enable = true;
  services.tor = {
    enable = true;
    settings = {
      HiddenServiceDir = "/var/lib/tor/monero-service";
      HiddenServicePort = "18081 127.0.0.1:18081";
    };
  };
  services.nginx = {
    enable = true;
    enableReload = true;
    virtualHosts."localhost" = {
      root = "/var/www/example";
    };
    virtualHosts."lu1.sh" = {
      addSSL = true;
      enableACME = true;
      root = "/var/www/lewis";
    };
    virtualHosts."lewistorrington.fi" = {
      addSSL = true;
      enableACME = true;
      root = "/var/www/lewis";
    };
    virtualHosts."heleneil.com" = {
      addSSL = true;
      enableACME = true;
      root = "/var/www/helene";
    };
    virtualHosts."blormo.com" = {
      addSSL = true;
      enableACME = true;
      root = "/var/www/agnes";
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "acme.limb074@passinbox.com";
  }; 

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 80 443 18081 ];
  networking.firewall.allowedUDPPorts = [ 80 443 18081 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  environment.variables.EDITOR = "nvim";

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = ''
        set number
        " set relativenumber
        " syntax off
        syntax on
        set mouse=a
        set tabstop=4
        set shiftwidth=4
        set expandtab
        set wrap
        set showmatch
        set cmdheight=2
        set incsearch
        set hlsearch
        set clipboard=unnamedplus
        colorscheme blue 
        filetype plugin on
        filetype indent on
        set numberwidth=5
        set signcolumn=yes
      '';
    };
  };
}
