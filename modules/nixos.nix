{
  lib,
  config,
  inputs,
  unify-lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.unify.hosts.nixos = mkOption {
    type = types.attrsOf (
      types.submodule (
        { name, ... }:
        {
          options = config.unify.options // {
            name = mkOption {
              default = name;
              readOnly = true;
            };
            user = mkOption {
              type = types.str;
              default = config.unify.user;
            };
            args = mkOption {
              type = types.lazyAttrsOf types.raw;
              default = { };
            };
            tags = mkOption {
              type = types.listOf types.str;
              default = [ ];
            };
            nixos = unify-lib.nixosModuleType;
            home = unify-lib.nixosModuleType;
          };
        }
      )
    );
  };

  config = {
    flake.nixosConfigurations = lib.mapAttrs (
      hostname: hostConfig:
      let
        filteredModules = unify-lib.filterUnifyModules hostConfig.tags;
        nixosModules = unify-lib.collectNixosModules filteredModules;
        homeManagerModules = unify-lib.collectHomeModules filteredModules;
        specialArgs = {
          inherit (hostConfig) tags;
          inherit hostConfig;
        } // hostConfig.args;
      in
      inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = nixosModules ++ [
          hostConfig.nixos
          config.unify.nixos
          inputs.home-manager.nixosModules.default
          {
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.${hostConfig.user}.imports = homeManagerModules ++ [
              hostConfig.home
              config.unify.home
            ];
          }
        ];
      }
    ) config.unify.hosts;
  };
}
