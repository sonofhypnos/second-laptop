# This file is for my Raspberry pi home stuff. The home stuff for my laptop is
#currently not ported to flakes and is in my dotfiles.

{ config, lib, pkgs, ... }: {

  imports = [ ./1password.nix ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "tassilo";
  home.homeDirectory = "/home/tassilo";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.packages = with pkgs; [
    zotero
    signal-desktop
    zathura
    google-chrome
    ranger
    python3
    htop
    zsh-autosuggestions
    zsh-syntax-highlighting
    trash-cli
    discord
    dropbox
    emacs
    # The below is to install the repository git-remote-dropbox
    (python3Packages.buildPythonApplication {
      pname = "git-remote-dropbox";
      version = "2.0.4"; # Update this to the latest version

      src = pkgs.fetchFromGitHub {
        owner = "anishathalye";
        repo = "git-remote-dropbox";
        rev = "v2.0.4"; # Update this to match version
        sha256 =
          "sha256-miA8lYfk77pXn5aWIh17uul1l+7w2VCBDT3+YiVK5OY="; # Add SHA256 after first attempt
      };
      format = "pyproject";

      nativeBuildInputs = with pkgs.python3Packages; [
        hatchling
        hatch-vcs
        poetry-core
        setuptools
      ];

      propagatedBuildInputs = with python3Packages; [
        dropbox
        setuptools
        requests
      ];

      doCheck = false; # Skip tests as they might require Dropbox credentials
    })
  ];

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "Tassilo Neubauer";
      userEmail = "46806445+sonofhypnos@users.noreply.github.com";
    };

    vim = {
      enable = true;
      # defaultEditor = true;
    };

    zsh = {
      enable = true;
      #make tramp recognize the shell by disabeling nix
      initExtraFirst =
        ''[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return'';
      shellAliases = {
        ll = "ls -l";
        #    update = "sudo nixos-rebuild switch";
      };
      history = {
        size = 100000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      #autosuggestions.enable = true;
      oh-my-zsh = {
        enable = true;
        #syntaxHighlighting = true;
        plugins = [ "git" "alias-finder" "colored-man-pages" "fasd" ];
        #FIXME:customPkgs seems to not be available anymore because I changed my nix-version?
        #    customPkgs = [
        #      pkgs.nix-zsh-completions
        #    ];
        theme = "robbyrussell";
      };
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

  };
  home.sessionVariables = {
    TERMINAL = "kitty";
    DEFAULT_TERMINAL = "kitty";
  };
  systemd.user.services.dropbox = {
    Unit = { Description = "Dropbox service"; };
    Install = { WantedBy = [ "default.target" ]; };
    Service = {
      ExecStart = "${pkgs.dropbox}/bin/dropbox";
      Restart = "on-failure";
    };
  };
}

