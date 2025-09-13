{
  lib,
  unify-lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.unify = {
    nixos = unify-lib.moduleType "Global NixOS configuration";
    home = unify-lib.moduleType "Global Home-Manager configuration";
    modules = mkOption {
      type = types.lazyAttrsOf (
        types.submodule {
          options = {
            nixos = unify-lib.moduleType "A NixOS module";
            home = unify-lib.moduleType "A Home-Manager module";
          };
        }
      );
    };
  };
  config.flake.modules = {
    nixos =
      lib.mapAttrs (moduleName: moduleConfig: moduleConfig.nixos) config.unify.modules
      // {
        default.imports = config.unify.nixos.imports;
      };
    homeManager =
      lib.mapAttrs (moduleName: moduleConfig: moduleConfig.home) config.unify.modules
      // {
        default.imports = config.unify.home.imports;
      };
  };
}
