{ lib, config, ... }:
let
  inherit (lib) mkOption types;
  moduleType =
    description:
    mkOption {
      type = types.deferredModule;
      default = { };
      inherit description;
    };
in
{
  _module.args.unify-lib = {

    nixosModuleType = moduleType "A NixOS module";
    homeModuleType = moduleType "A home-manager module";
    darwinModuleType = moduleType "A nix-darwin module";

    # Returns list of nixosModules
    collectNixosModules = modules: lib.fold (v: acc: acc ++ v.nixos.imports) [ ] modules;

    # Returns list of homeManagerModules
    collectHomeModules = modules: lib.fold (v: acc: acc ++ v.home.imports) [ ] modules;
  };
}
