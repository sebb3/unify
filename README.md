# Unify
Unify is a library that lets you configure NixOS, nix-darwin, and home-manager configurations in the same modules.

It is built using the module system provided by [Auxolotl Lib](https://git.auxolotl.org/auxolotl/lib) and is currently made to be used with [Nilla](https://github.com/nilla-nix/nilla) and the CLI provided by [nilla-utils](https://github.com/arnarg/nilla-utils). I plan to eventually add an option to use the Nixpkgs module system instead as well as provide a flake.

This project is heavily inspired the amazing [Denix](https://github.com/yunfachi/denix) library, which shares the goal of combining NixOS and home-manager configurations. 

# Features
Unify lets you define NixOS, nix-darwin and home-manager configurations in the same modules. This lets the same files handle multiple system types, making it easier to share configuration between them. Unify options can be designed to easily configure options for multiple configuration types at once. My [NixOS configurations](https://codeberg.org/quasigod/nixconfig) have not yet been transfered to Unify, but you can still see the utility of this feature by looking at how they Denix modules to accomplish the same thing.

Unify hosts automatically import all Nix files in the paths you specify, including the files of other hosts. Since host specific configuration is kept in `config.host.${hostname}`, you can easily combine host specific and shared configurations in a single file. I like to use this for things like IP address, hostnames, and Syncthing IDs, stuff that is related to one host, but will be used by others.

config.args defines an attribute set that lets you easily add module args. host, homeConfig, and osConfig args are included by default. 

My goal is for Unify to be a very simple framework The module system should allow for features to be easily added to a configuration without needing to be added to Unify itself. Most features beyond what I mention here will likely be built into separate Unify modules.  

# Docs
Proper docs will be added in the future, but for now, here's the basics.

NixOS options are set in `config.nixos`, nix-darwin in `config.darwin`, and home-manager in `config.home`. Unify options can be defined with the top level option attrset and configured in `config`. Host specific options are put in `host.${hostname}.nixos/darwin/home`. A very basic example can be seen in the `test` directory. 

Anything else you need to know, you should hopefully be able to find in the code. It's barely documented, but it's also not very complicated.

# Note
This software is pre-pre-pre-alpha quality and pretty much completely untested. I would not recommend trying to use it for anything besides some experimentation until I have time to transfer my own config and properly test it out, which will hopefully be soon!