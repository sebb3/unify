{ lib, unify-lib, ... }:
let
  inherit (lib) mkOption types;
  nixos = unify-lib.nixosModuleType;
  home = unify-lib.homeModuleType;
in
{
  options.unify = {
    inherit nixos home;
    modules = mkOption {
      type = types.lazyAttrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              inherit nixos home;
              tag = mkOption {
                default = name;
                readOnly = true;
                description = "Modules will be applied to hosts with this tag";
              };
            };
          }
        )
      );
    };
  };
}
