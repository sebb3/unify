let
  pins = import ./npins;
  nilla = import pins.nilla;
in
nilla.create (
  { config }:
  {
    includes = [
      "${pins.nilla-utils}/modules"
      ./unify.nix
    ];
    config = {
      inputs = {
        nixpkgs.src = pins.nixpkgs;
        home-manager.src = pins.home-manager;
        nilla-utils.src = pins.nilla-utils;
      };
      modules.unify = ./unify.nix;
      lib = import ./lib.nix { inherit (config) lib; };
      unify.hosts.unify-test = {
        type = "nixos";
        user = "unify";
        paths = [ ./test ];
        system = "x86_64-linux";
      };
      shells.default = {
        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ];
        shell = let
          nilla-utils = config.inputs.nilla-utils.result.packages.default.result;
        in
          { mkShell, pkgs }:
          mkShell {
            packages = [ nilla-utils.${pkgs.system} ];
          };
      };
    };
  }
)
