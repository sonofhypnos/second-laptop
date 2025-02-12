{ config, lib, pkgs, ... }: {
  home.username = "leo";
  home.homeDirectory = "/home/leo";

  home.packages = with pkgs; [
    firefox
    plasma5Packages.discover
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

  home.stateVersion = "24.05";
}
