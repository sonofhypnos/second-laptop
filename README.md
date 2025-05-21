# Info
This is my nixos configuration for my T460 Thinkpad. 

# Installation

To run nixos config and home-manager:
```sh
sudo nixos-rebuild switch --flake .#nixos
```

You can also run home-manager alone (Not sure if I should separate home-manager out of the config that is triggered by the previous command)

``` sh
home-manager switch --flake .#tassilo
```

Your inputs for the flake will not change if you don't run 

``` sh
nix flake update
```
Which will update the lock file (so this would be advisable if say signal needs a new version)


# Background info
- to connect to wifi:
  use the cli tool `nmtui`

# TODOS
- setup a software for screenshots

