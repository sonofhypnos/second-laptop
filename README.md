# Info
This is my nixos configuration for my T460 Thinkpad. 

# Installation

```sh
sudo nixos-rebuild switch --flake .#nixos
```


# Background info
- What the hell are flakes?
  - My best current understanding is that flakes define configuration in a way that doesn't require the config files to be in a particular place (like /etc/nixos/). This is useful for version control etc.
- to connect to wifi run:
  nmcli device wifi connect $wifiname password $wifipassword

# TODOS
- setup a software for screenshots

