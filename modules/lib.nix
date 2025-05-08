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

    # Gets Unify modules matching host tags
    filterUnifyModules = tags: lib.filterAttrs (n: v: lib.elem v.tag tags) config.unify.modules;

    # Returns list of nixosModules
    collectNixosModules =
      modules: lib.fold (v: acc: acc ++ v.nixos.imports) [ ] (lib.attrValues modules);

    # Returns list of homeManagerModules
    collectHomeModules = modules: lib.fold (v: acc: acc ++ v.home.imports) [ ] (lib.attrValues modules);

  };
}
