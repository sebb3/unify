{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  imports = [
    ./host.nix
    ./modules.nix
    ./lib.nix
  ];
  options.unify = {
    user = mkOption { type = lib.types.str; };
    options = mkOption {
      type = types.lazyAttrsOf types.raw;
      default = { };
    };
  };
}
