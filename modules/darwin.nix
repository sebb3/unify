{
  lib,
  config,
  inputs,
  withSystem,
  unify-lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.unify.hosts.darwin = mkOption {
    type = types.attrsOf (
      types.submodule (
        { name, ... }:
        let
          modules = mkOption {

            type = types.listOf (
              types.submodule {
                options = {
                  darwin = unify-lib.moduleType "A Darwin module";
                  home = unify-lib.moduleType "A Home-Manager module";
                  nixos = unify-lib.moduleType "Nixos modules (will be dropped)";
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
            darwin = unify-lib.moduleType "Host-specific Darwin configuration";
            home = unify-lib.moduleType "Host-specific home-manager configuration, applied to all users for host.";
          };
        }
      )
    );
  };

  config = {
    flake.darwinConfigurations =
    lib.mapAttrs (
      hostname: hostConfig:
      let
        darwinModules =
          (unify-lib.collectDarwinModules hostConfig.modules)
          ++ [ config.unify.darwin ]
          ++ hostConfig.darwin.imports;

        homeModules = [
          config.unify.home
          hostConfig.home
        ];

        users = lib.mapAttrs (_: v: {
          imports = (unify-lib.collectHomeModules v.modules) ++ v.home.imports ++ homeModules;
        }) hostConfig.users;

        specialArgs = {
          inherit hostConfig;
        }
        // hostConfig.args;
      in
      withSystem "aarch64-darwin" (
        args:
        inputs.nix-darwin.lib.darwinSystem {
            pkgs = args.final;
            inherit specialArgs;
            modules = darwinModules ++ [
            inputs.home-manager.darwinModules.home-manager
            {
                home-manager.extraSpecialArgs = specialArgs;
                home-manager.users = users;
            }
            ];
        }
    )) config.unify.hosts.darwin;
  };
}
