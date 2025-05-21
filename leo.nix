{ config, lib, pkgs, ... }: {
  home.username = "leo";
  home.homeDirectory = "/home/leo";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    firefox
    #plasma5Packages.discover # FIXME: Try this package again from the newest release?
    google-chrome
    # Add Leo-specific packages
  ];

  programs = {
    home-manager.enable = true;
    # Add Leo-specific program configs
  };

  # KDE Plasma settings
  xsession = {
    enable = true;
    windowManager.command = "startplasma-x11";
  };

  # Basic KDE preferences (optional)
  dconf.settings = {
    # Add KDE-specific settings
  };

}
