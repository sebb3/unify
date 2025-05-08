{ lib, ... }:
{
  listNixFiles =
    dirs:
    builtins.foldl' (
      acc: elem:
      acc
      ++ (builtins.filter (n: lib.strings.hasSuffix ".nix" n) (lib.filesystem.listFilesRecursive elem))
    ) [ ] dirs;

  configureHost =
    config: hostname: type:
    let
      hostConfig = config.host;
    in
    if hostConfig.name == hostname then lib.unify hostConfig type else lib.unify hostConfig.shared type;

  # Take Unify modules and return modules for system type
  mkHostModule =
    {
      hostname,
      type,
      user,
      config,
    }:
    let
      hostConfig = builtins.getAttr hostname config.host;
      homeConfigs = [
        {
          home-manager.users.${user} = config.home;
        }
        {
          home-manager.users.${user} = hostConfig.home;
        }
      ];
    in
    if type == "nixos" then
      [
        config.nixos
        hostConfig.nixos
      ]
      ++ homeConfigs
    else if type == "home-manager" then
      [
        config.home
        hostConfig.home
      ]
    else if type == "darwin" then
      [
        config.darwin
        hostConfig.darwin
      ]
      ++ homeConfigs
    else
      throw "${type} is not a valid system type! Valid types are nixos, home-manager, or darwin";
}
