{lib, ...}: let
  inherit (lib) mkOption types;
in {
  imports = [
    ./nixos.nix
    ./darwin.nix
    ./modules.nix
    ./lib.nix
  ];
  options.unify = {
    options = mkOption {
      type = types.lazyAttrsOf types.raw;
      default = {};
    };
  };
}
