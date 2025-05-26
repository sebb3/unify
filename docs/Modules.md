# Modules

Modules are reusable parts of a Nix configuration. Unify provides options to simplify writing modules. Here is an example of a file that contains a NixOS and Home-Manager module configuring COSMIC DE.

```
{
  unify.modules.cosmic = {
    home =
      { pkgs, ... }:
      {
        xdg.configFile = {
          # using cosmics automatic gtk theming
          "gtk-4.0/assets".enable = false;
          "gtk-4.0/gtk.css".enable = false;
          "gtk-4.0/gtk-dark.css".enable = false;
        };
        gtk.iconTheme = {
          name = "Cosmic";
          package = pkgs.cosmic-icons;
        };
      };

    nixos =
      { pkgs, ... }:
      {
        services = {
          desktopManager.cosmic.enable = true;
          displayManager.cosmic-greeter.enable = true;
        };
      };
  };
}
```

Unify also supports an unnamed module that will be imported by all hosts and users by default. These modules can be defined using `unify.nixos` and `unify.home`.

Modules defined by unify will also be added to your flake outputs, allowing them to be reused by other flakes. 

Next: [[Hosts.md]]
