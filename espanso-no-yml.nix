{ config, lib, pkgs, ... }:

let cfg = config.services.espanso;
in {
  config = lib.mkIf cfg.enable {
    xdg.configFile =
      lib.mkForce { }; # Force-clears the file generation from home-manager
  };
}
