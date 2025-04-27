{ config }:
let
  inherit (config) inputs lib;
in
{
  options.unify = {
    hosts = lib.options.create {
      description = "Unified hosts to create";
      default.value = { };
      type = lib.types.attrs.of (
        lib.types.submodule {
          options = {
            args = lib.options.create {
              description = "Additional arguments to pass to host modules.";
              type = lib.types.attrs.any;
              default.value = { };
            };

            # system = lib.options.create {
            #   description = "The host platform";
            #   type = lib.types.enum config.loaders.nixpkgs.settings.default.systems;
            # };

            nixpkgs = lib.options.create {
              description = "The Nixpkgs input to use.";
              type = lib.types.raw;
              default.value =
                if inputs ? nixpkgs && inputs.nixpkgs.result ? x86_64-linux then
                  inputs.nixpkgs.result.x86_64-linux
                else
                  null;
            };

            paths = lib.options.create {
              description = "Paths to recursively import nix files from.";
              type = lib.types.list.of lib.types.path;
              default.value = [ ];
            };

            type = lib.options.create {
              description = "The type of Unify host";
              type = lib.types.enum [
                "nixos"
                # "home-manager"
                # "darwin"
              ];
              default.value = "nixos";
            };

            extraModules = lib.options.create {
              description = "A list of extra Unify modules to include.";
              type = lib.types.list.of lib.types.raw;
              default.value = [ ];
            };

            user = lib.options.create {
              description = "User to use for home-manager configuration.";
              type = lib.types.string;
            };

            auxLib = lib.options.create {
              description = "Use Aux lib for module system (experimental)";
              type = lib.types.bool;
              default.value = false;
            };
          };
        }

      );
    };
  };

  config.systems.nixos = builtins.mapAttrs (
    hostname: hostConfig:
    let
      modules = lib.listNixFiles (hostConfig.paths ++ hostConfig.extraModules);
      unifyResult =
        if hostConfig.auxLib then
          lib.modules.run {
            modules = ([ ./modules/aux ] ++ modules);
            args = hostConfig.args // {
              inherit hostname hostConfig;
              pkgs = hostConfig.nixpkgs;
              pkgsLib = hostConfig.nixpkgs.lib;
            };
          }
        else
          hostConfig.nixpkgs.lib.evalModules {
            modules = [
              {
                config._module.args = hostConfig.args // {
                  inherit hostname hostConfig;
                  pkgs = hostConfig.nixpkgs;
                  auxLib = lib;
                };
              }
              ./modules/nixpkgs-lib
            ] ++ modules;
          };
      homeModule =
        if hostConfig.type == "nixos" then
          inputs.home-manager.result.nixosModules.default
        else if hostConfig.type == "darwin" then
          inputs.home-manager.result.darwinModules.default
        else
          null;
      hostModules =
        [ homeModule ]
        ++ (lib.mkHostModule {
          inherit hostname;
          inherit (hostConfig) type user;
          inherit (unifyResult) config;
        });
    in
    {
      # inherit (hostConfig) system;
      pkgs = hostConfig.nixpkgs;
      modules = hostModules;
    }
  ) config.unify.hosts;
}
