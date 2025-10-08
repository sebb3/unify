# Unify

Fork from [Unify](https://codeberg.org/quasigod/unify)


Unify is a library that helps you create your configurations using flake-parts modules. It is designed to make it simple to configure NixOS, and home-manager (and eventually nix-darwin and system-manager) together. The goal is to reduce separation between flake, NixOS, and home-manager configuration, allowing everything to easily be configured in the same files. 

This project was inspired by [Denix](https://github.com/yunfachi/denix), [mightyiam's Infra flake](https://github.com/mightyiam/infra), and the [Dendritic Pattern](https://github.com/mightyiam/dendritic) where each file is a flake-parts module.

This is currently very experimental and only tested in my own configuration. Basically everything here may completely change in the future. If you'd like to try it, take a look at my [NixOS/home-manager configuration](https://codeberg.org/quasigod/nixconfig).
