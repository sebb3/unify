{ lib }:
{
  includes = [
    ./host.nix
    ./args.nix
  ];
  options =
    let
      unifyOption = lib.options.create {
        type = lib.types.attrs.any;
        default.value = { };
      };
    in
    {
      nixos = unifyOption;
      home = unifyOption;
      system = unifyOption;
      darwin = unifyOption;
    };
}
