{
  inputs = {
   nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
#        ./T460-hardware.nix
        ./configuration.nix
        ./common-configuration.nix
        ./vim.nix
        home-manager.nixosModules.home-manager
      ];
    };
  };
}
