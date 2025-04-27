let
  pins = import ./npins;
  nilla = import pins.nilla;
in
nilla.create (
  { config }:
  {
    includes = [
      "${pins.nixos}/modules/nixos.nix"
      ./unify.nix
    ];
    config = {
      modules.unify = ./unify.nix;
      lib = import ./lib.nix { inherit (config) lib; };
    };
  }
)
