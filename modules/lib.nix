{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
  moduleType =
    description:
    mkOption {
      type = types.deferredModule;
      inherit description;
    };
in
{
  _module.args.unify-lib = {
    inherit moduleType;

    # Returns list of nixosModules
    collectNixosModules = modules: lib.fold (v: acc: acc ++ v.nixos.imports) [ ] modules;

    # Returns list of darwinModules
    collectDarwinModules = modules: lib.fold (v: acc: acc ++ v.darwin.imports) [ ] modules;

    # Returns list of homeManagerModules
    collectHomeModules = modules: lib.fold (v: acc: acc ++ v.home.imports) [ ] modules;
  };
}
