# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  #todo: test eve (forgot what that is)

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d -d";
  };
  nix.package = pkgs.lix; # Saw claim lix is faster. Should measure that though.

  # Enable the unfree 1Password packages
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "1password-gui"
      "1password"
      "1password-cli"
      "discord"
      "dropbox"
      "google-chrome"
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];

  # Set your time zone.
  time.timeZone = "Australia/Melbourne";

  nixpkgs.overlays = [
    (self: super: {
      neovim = super.neovim.override {
        viAlias = true;
        vimAlias = true;
      };
    })
  ];

  environment.pathsToLink = [ "/libexec" ];

  services = {

    libinput.enable = true;

    displayManager = {
      sddm.enable = true;
      defaultSession = "none+i3";
    };

    desktopManager.plasma6.enable = true;

    xserver = {
      enable = true;

      # Configure keymap in X11
      xkb = {
        # layout = "us,de,de"; NOTE: use the commented out version if you want to let your gf or your mother use the keybord
        # variant = ",, neo_qwertz";
        layout = "de";
        variant = "neo_qwertz";
        options = "grp:alt_space_toggle";
      };

      # Enable touchpad support (enabled default in most desktopManager).
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [ dmenu i3status i3lock i3blocks ];
      };
    };

    # Enable the OpenSSH daemon.
    openssh.settings.PasswordAuthentication = true;
    openssh.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };

    # Enable CUPS to print documents.
    #printing.enable = true;
  };

  # Enable sound.
  # rtkit is optional but recommended
  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    tassilo = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.

      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCSadWNNn6VXcoYng7QrNbr6JNcgMUlrvb9INu0a1Ox6pQro2YLJvU5CGMEi9P5KKQrFSvPDlkwd/uUMmOr7jbZfE5iWWYHxqjDo+FI6+a2vpymWdotGBFdPcGzet2X9HW1hbeOHySTIwStfSRO/Fx43uy5Hxq1Fd/Up2kslQyUxxSVd7GFrfe0bJkv1tozoR/UixrBMin2OfI9T0nvG+HuZ51PF5ukrkogEaXFwtoS1jYrY2gk1GLRYEP5WiL7s9k7nJJ3DyHejCRk4XJP/szCRxa7zRSed5ussYfRZXr1KLiauvkfvBvB14ACuLVSKz8dyo/6C6zLLJxrvpDSgjgrz3kyJlqWTPsR3fBoVemqLta5vPLKCv53LTopa9p0ySvKPo3i3pQS5jHwtD9OOiuSyYzZOoxVG9motWjsXlB6P927XCoDfb+0kke0kYWsdlUaO2G+fDcQpEjH1borz74LP/YIDE/nh7jEMR2VwgYhAsyILfGsxpqt6OyUDwoxkgs= tassilo@tassilo-ThinkPad-E15-Gen-2"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDLSQ/5TgxGqerDlA+CCHY/NrLkonlVSgI9cbkgrsHsAQAe8kS7tvBZpTFhZyYYQz0O3x70IF1NYD0ZJ/DjOyPzQZXr3efA0EYwisRF83A7AAhhBUs2jxcbHeTwgEYg9cboCPw97dJPfAhAjC+8SE6DMUJT2Fvyxb9fyKUxhzd6CI0KKm3MlO4qwOXyA/RM/4xtnIgO+lYvZ7OZmluSQi9DU2UyCvHads/YlPGbnKmw888Sc7QhqE3eq42lSU7995aZDF0kH4qcoXmV8ugRJ+5OKRRgFkcky8j6r/LkYaK4HHe4Qa3CSBJjQHOmd7Vfu51LJfedfTWJaOfuvEgYV69c2xc0Iwbi2VDNfGSS/9LWxh+H2GbMllIp+lKlZtASQfvgMPSfLgRa+cbhcwwwcV58Qrk3QdED6ESQL7kZmuIyVWSAzBbHsb12O6SgGIQiLsGiqcUWKRwudH4iw1jWWtvb0WJxeUbqKglPjMMCYRg57ym+LhMmNiF5ydjLrJHyogM= tassilo@t-dell"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCQSROiZcNSIT0jynq6EXEa6ne9ApY0OUfh96qLBDL4pUsFW3KhHouiC9weQp31QXxckTC7rdvSNe6YkchrpT0KHi/tkTmgAoYX9pQv0guYUymOinj95Q+PJYMviotRzVlpB01GcZ/XlTaUZZV0HgUlto8TiMX2ILAbxvHzo1a0GNUw4xBBEZvOg2xSL26rcogqKibMv9jothkEVLRHydrNWzGZtXopOk1eGXh6qOl8bVB38XuZK3AHyqJtfUZb5Zj8nkKPrHn9spVpyt8J4xb43tTHKvtwWGWTTZixZBBUgugHAhgQIAaP/3T0Dw2gndPsyhmqZeO0Iy6Lv9r1fsUxzgh2PPjjmP/AZtphU9lCGx7Gy6+FahsYlXPPGEZRljn64jN9v4u15xTx6cmn0LuxvTrntM6p+ruIPzWVrNK/4XQwFjlbDO1UD/ToePoUaKtNR5AngeeTp/9/wObmfwolJQgx4miq/Jvsdx0+FlIX8hzAU4hjDMFNd1UonI/9f3M= root@tassilo-ThinkPad-E15-Gen-2"
      ];
    };
    natalie = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
    };

    leo = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.tassilo = {

      programs.zsh.enable = true;
      imports = [ ./home.nix ];
    };

    users.leo = {
      imports = [ ./leo.nix ];
      home.stateVersion = "25.11";
      xsession.enable = true;
      xsession.windowManager.command = "startplasma-x11";

    };
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCQSROiZcNSIT0jynq6EXEa6ne9ApY0OUfh96qLBDL4pUsFW3KhHouiC9weQp31QXxckTC7rdvSNe6YkchrpT0KHi/tkTmgAoYX9pQv0guYUymOinj95Q+PJYMviotRzVlpB01GcZ/XlTaUZZV0HgUlto8TiMX2ILAbxvHzo1a0GNUw4xBBEZvOg2xSL26rcogqKibMv9jothkEVLRHydrNWzGZtXopOk1eGXh6qOl8bVB38XuZK3AHyqJtfUZb5Zj8nkKPrHn9spVpyt8J4xb43tTHKvtwWGWTTZixZBBUgugHAhgQIAaP/3T0Dw2gndPsyhmqZeO0Iy6Lv9r1fsUxzgh2PPjjmP/AZtphU9lCGx7Gy6+FahsYlXPPGEZRljn64jN9v4u15xTx6cmn0LuxvTrntM6p+ruIPzWVrNK/4XQwFjlbDO1UD/ToePoUaKtNR5AngeeTp/9/wObmfwolJQgx4miq/Jvsdx0+FlIX8hzAU4hjDMFNd1UonI/9f3M= root@tassilo-ThinkPad-E15-Gen-2"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    home-manager
    signal-desktop # Signal installed here, since it always wants a bleeding edge version

    # NOTE: some of the below might be better installed via home-manager.
    # Haskell
    haskell-language-server
    ghc

    #else
    ausweisapp
    jetbrains.pycharm-community-src
    kdePackages.okular
    wget
    git
    ripgrep
    neovim
    vimHugeX
    firefox
    copyq
    zsh
    oh-my-zsh
    fzf
    parted
    borgbackup
    nettools
    xclip # Without xclip, neovim has no clipboard
    rxvt-unicode-unwrapped
  ];
  fonts.packages = with pkgs; [ hermit source-code-pro terminus_font ];

  environment.variables.TERMINAL = "urxvt";

  programs = {
    firefox = {
      enable = true;
      nativeMessagingHosts.packages = [ pkgs.tridactyl-native ];
    };
    neovim = {
      enable = true; # this overwrites vim with neovim
      viAlias = true;
      #     plugins = [
      #     {
      #       plugin = nvim-colorizer-lua;
      #       config = packadd! nvim-colorizer.lua
      #       lua require 'colorizer'.setup();
      #       #there is something about erros when using default packages: https://nixos.wiki/wiki/Neovim
      #     }
      #   ];

    };
    zsh.enable = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall =
        true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall =
        true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall =
        true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      # Certain features, including CLI integration and system authentication support,
      # require enabling PolKit integration on some desktop environments (e.g. Plasma).
      # Perhaps this is also useful if I want wifi passwords to stay persistent?
      polkitPolicyOwners = [ "tassilo" ];
    };
  };

  nix = {
    #package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

}
