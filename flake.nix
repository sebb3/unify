{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      debug = true;
      imports = [
        flake-parts.flakeModules.flakeModules
        flake-parts.flakeModules.modules
        flake-parts.flakeModules.partitions
        ./modules
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      flake = {
        flakeModules.unify = ./modules;
        flakeModules.default = ./modules;
      };
      partitionedAttrs.nixosConfigurations = "tests";
      partitions.tests = {
        extraInputsFlake = ./test;
        module =
          { inputs, config, ... }:
          {
            imports = [
              config.flakeModule
              (inputs.import-tree ./test)
            ];
          };
      };
    };
}
