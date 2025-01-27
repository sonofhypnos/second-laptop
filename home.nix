# This file is for my Raspberry pi home stuff. The home stuff for my laptop is
#currently not ported to flakes and is in my dotfiles.

{ config, lib, pkgs, ... }: {

  imports = [
	./1password.nix
  ];
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
        Unit = {
            Description = "Dropbox service";
        };
        Install = {
            WantedBy = [ "default.target" ];
        };
        Service = {
            ExecStart = "${pkgs.dropbox}/bin/dropbox";
            Restart = "on-failure";
        };
    };
}

