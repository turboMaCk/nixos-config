# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  inherit (pkgs) callPackage;
  wire-desktop = callPackage ../applications/wire-desktop.nix {};

in {
  # imports =
  #  [ # Include the results of the hardware scan.
  #    ./hardware-configuration.nix
  #  ];

  # :'(
  nixpkgs.config = {
    allowUnfree = true;

    # chromium setup
    chromium = {
      # DRM shit for chromiume
      # enableWideVine = true;
      # enablePepperFlash = true;
      # enablePepperPDF = true;
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "nixos-mainframe"; # Define your hostname.
    networkmanager.enable = true;
    wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    # essentials
    wget
    vim_configurable
    chromium
    git
    pass
    rxvt_unicode
    xterm
    dmenu
    haskellPackages.xmobar
    gnupg
    python
    gcc
    gnumake

    # utils
    feh
    htop
    docker_compose

    # media
    transmission-gtk
    vlc
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;

  # SHELL

  programs.zsh.enable = true;


  # GnuPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.pcscd.enable = true;
  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # ? I'm using GPG for ssh instead ?

  # services.openssh.enable = true;
  # programs.ssh.startAgent = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;

  # HW support
  hardware = {

    # Sound config
    pulseaudio.enable = true;
    pulseaudio.support32Bit = true;

    # OpenGL
    opengl.driSupport32Bit = true;
  };

  # Fonts
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      anonymousPro
      corefonts
      dejavu_fonts
      font-droid
      freefont_ttf
      google-fonts
      inconsolata
      liberation_ttf
      powerline-fonts
      source-code-pro
      terminus_font
      ttf_bitstream_vera
      ubuntu_font_family
    ];
  };

  # X11 settings
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "eurosign:e";
    dpi = 130;
    libinput.enable = false; # touchbar

    # Display Manager
    displayManager = {
       sddm.enable = true;
       lightdm.enable = false;
    };

    desktopManager = {
      plasma5.enable = true;
      gnome3.enable = false;
      xfce.enable = false;
      default = "plasma5";
   };

    # Xmonad
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
         haskellPackages.xmonad-contrib
         haskellPackages.xmonad-extras
         haskellPackages.xmonad
      ];
    };
 };

  # compton
  services.compton = {
    enable          = true;
    fade            = true;
    inactiveOpacity = "1.0";
    shadow          = true;
    fadeDelta       = 4;
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.marek = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "vboxusers" "docker" ];
    shell = pkgs.zsh;

    packages = with pkgs; [
        steam
        browserpass
        dropbox
        obs-studio
        slack
        spotify
        firefox
        emacs
        wire-desktop

        # work
        nodejs-8_x
        elmPackages.elm
        elmPackages.elm-format
        yarn
    ];
  };

  ## SYSTEMD

  systemd.user.services."urxvtd" = {
    enable = true;
    description = "rxvt unicode daemon";
    wantedBy = [ "default.target" ];
    path = [ pkgs.rxvt_unicode ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.rxvt_unicode}/bin/urxvtd -q -o";
  };

  # Virtualization & Docker

  virtualisation = {
    docker.enable = true;

    virtualbox = {
        host.enable = true;
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?
}
