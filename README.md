# Unify
Unify is a library that helps you create your configurations using flake-parts modules. It is designed to make it simple to configure NixOS and home-manager together. The goal is to reduce separation between flake, NixOS, and home-manager configs, allowing everything to easily be configured in the same files. 

This project was inspired by [Denix](https://github.com/yunfachi/denix), [mightyiam's Infra flake](https://github.com/mightyiam/infra), and his post on the [NixOS Discourse sharing his "every file is a flake-parts module" pattern](https://discourse.nixos.org/t/pattern-every-file-is-a-flake-parts-module/61271/1).

This is currently very experimental and only tested in my own configuration. Basically everything here may completely change in the future. If you'd like to try it, take a look at my [NixOS/home-manager configuration](https://codeberg.org/quasigod/nixconfig).