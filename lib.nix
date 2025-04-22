{ lib, ... }:
{
  mergeAttrsList =
    list:
    let
      # `binaryMerge start end` merges the elements at indices `index` of `list` such that `start <= index < end`
      # Type: Int -> Int -> Attrs
      binaryMerge =
        start: end:
        # assert start < end; # Invariant
        if end - start >= 2 then
          # If there's at least 2 elements, split the range in two, recurse on each part and merge the result
          # The invariant is satisfied because each half will have at least 1 element
          binaryMerge start (start + (end - start) / 2) // binaryMerge (start + (end - start) / 2) end
        else
          # Otherwise there will be exactly 1 element due to the invariant, in which case we just return it directly
          builtins.elemAt list start;
    in
    if list == [ ] then
      # Calling binaryMerge as below would not satisfy its invariant
      { }
    else
      binaryMerge 0 (builtins.length list);

  # from nixpkgs, modified for aux lib
  listFilesRecursive =
    dir:
    lib.lists.flatten (
      lib.attrs.mapToList (
        name: type:
        if type == "directory" then lib.listFilesRecursive (dir + "/${name}") else dir + "/${name}"
      ) (builtins.readDir dir)
    );

  listNixFiles =
    dirs:
    builtins.foldl' (
      acc: elem:
      acc ++ (builtins.filter (n: lib.strings.hasSuffix ".nix" n) (lib.listFilesRecursive elem))
    ) [ ] dirs;

  configureHost =
    config: hostname: type:
    let
      hostConfig = config.host;
    in
    if hostConfig.name == hostname then lib.unify hostConfig type else lib.unify hostConfig.shared type;

  # Take Unify modules and return modules for system type
  mkHostModule = { hostname, type, user, config, }: 
    let
      hostConfig = lib.attrs.selectOrThrow [ hostname ] config.host;
      homeConfig = {
        home-manager.users.${user} = lib.attrs.mergeRecursive config.home hostConfig.home;
      };
    in
    if type == "nixos" then
      [ config.nixos homeConfig hostConfig.nixos ]
    else if type == "home-manager" then
      [ config.home ]
    else if type == "darwin" then
      [ config.darwin homeConfig ]
    else
      throw "${type} is not a valid system type! Valid types are nixos, home-manager, or darwin";
}
