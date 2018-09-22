{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    vim_configurable
    git
    pass
    gnupg
    python
    python3
    gcc
    gnumake
    htop
  ];

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # ZSH
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

}
