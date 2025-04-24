{ lib, ... }:
{
  imports = [
    ./host.nix
    ./args.nix
  ];
  options =
    let
      unifyOption = lib.mkOption {
        type = lib.types.attrs;
        default = { };
      };
    in
    {
      nixos = unifyOption;
      home = unifyOption;
      system = unifyOption;
      darwin = unifyOption;
    };
}
