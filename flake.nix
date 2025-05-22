{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let system = "x86_64-linux";
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        # NOTE: Modules are just a set of functions (See the colon used at the beginning when defining a module), that get forwarded a few special arguments.
        # pkgs (the nixpkgs package set)
        # lib ()
        #
        modules = [
          # ./T460-hardware.nix
          ./configuration.nix
          ./common-configuration.nix
          ./vim.nix
          home-manager.nixosModules.home-manager
        ];
        #NOTE SpecialArgs is the idiomatic way for nix to add additional arguments to modules
        # We are not using this below to show another way to add custom
        # packages, which is via overlays (overlays are just a list of functions
        # with a specific type signature that return packages)
        #specialArgs = { codexCli = codex.packages.${system}.codex-cli; };
      };
      homeConfigurations.tassilo = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree =
            true; # FIXME: possibly refactor restrictions in common-configuration to apply here as well?
          overlays = [
            (final: prev: { x11trace = final.callPackage ./x11trace.nix { }; })
          ];
        };
        modules = [ ./home.nix ];
        extraSpecialArgs = { system = "x86_64-linux"; };
      };
    };
}
