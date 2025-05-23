{
  lib,
  unify-lib,
  config,
  ...
}:
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
  config.flake.modules = {
    nixos = lib.mapAttrs (moduleName: moduleConfig: {
      imports = [ moduleConfig.nixos.imports ];
    }) config.unify.modules // {
      default.imports = config.unify.nixos.imports;
    };
    home = lib.mapAttrs (moduleName: moduleConfig: {
      imports = [ moduleConfig.home.imports ];
    }) config.unify.modules // {
      default.imports = config.unify.home.imports;
    };
  };
}
