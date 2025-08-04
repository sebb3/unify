<!--toc:start-->
- [Introduction](#introduction)
  - [Getting started](#getting-started)
<!--toc:end-->

# Introduction
Unify is a Nix library designed to help you define hosts by following a pattern where every file in your configuration is a flake-parts module. 

Files allow you to define named NixOS and Home-Manager modules and hosts that import these modules. 

## Getting started
The following example `flake.nix` is all you need before starting to create your [modules](Modules.md) and [hosts](Hosts.md). `import-tree` is used to import every \*.nix file in the `./modules` directory.

```nix
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    unify = {
      url = "git+https://codeberg.org/quasigod/unify";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };


  outputs =
    { flake-parts, import-tree, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.unify.flakeModule
        (import-tree [
          ./modules
        ])
      ];
    };
```

Next: [Modules.md](Modules.md)
