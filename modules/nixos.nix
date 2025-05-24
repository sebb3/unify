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
        let
          modules = mkOption {
            type = types.listOf (types.submodule {
              options = {
                nixos = unify-lib.nixosModuleType;
                home = unify-lib.nixosModuleType;
              };
            });
            default = [ ];
          };
        in
        {
          options = config.unify.options // {
            inherit modules;
            name = mkOption {
              default = name;
              readOnly = true;
            };
            users = mkOption {
              type = types.lazyAttrsOf (types.submodule {
                options = { inherit modules; };
              });
              default = { };
            };
            args = mkOption {
              type = types.lazyAttrsOf types.raw;
              default = { };
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
        nixosModules = (unify-lib.collectNixosModules hostConfig.modules) ++ [
          config.unify.nixos
          hostConfig.nixos
        ];
        homeModules = (unify-lib.collectHomeModules hostConfig.modules) ++ [
          config.unify.home
          hostConfig.home
        ];

        users = lib.mapAttrs (_: v: { imports = (unify-lib.collectHomeModules v.modules) ++ homeModules; }) hostConfig.users;

        specialArgs = {
          inherit hostConfig;
        } // hostConfig.args;

      in
      inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = nixosModules ++ [
          inputs.home-manager.nixosModules.default
          {
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users = users;
          }
        ];
      }
    ) config.unify.hosts.nixos;
  };
}
