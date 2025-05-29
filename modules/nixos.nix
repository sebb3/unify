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
            type = types.listOf (
              types.submodule {
                options = {
                  nixos = unify-lib.moduleType "A NixOS module";
                  home = unify-lib.moduleType "A Home-Manager module";
                };
              }
            );
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
              type = types.lazyAttrsOf (
                types.submodule {
                  options = {
                    inherit modules;
                    home = unify-lib.moduleType "User-specific home-manager configuration";
                  };
                }
              );
              default = { };
            };
            args = mkOption {
              type = types.lazyAttrsOf types.raw;
              default = { };
            };
            nixos = unify-lib.moduleType "Host-specific NixOS configuration";
            home = unify-lib.moduleType "Host-specific home-manager configuration, applied to all users for host.";
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
          hostConfig.nixos.imports
        ];

        homeModules = [
          config.unify.home
          hostConfig.home
        ];

        users = lib.mapAttrs (_: v: {
          imports = (unify-lib.collectHomeModules v.modules) ++ v.home.imports ++ homeModules;
        }) hostConfig.users;

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
