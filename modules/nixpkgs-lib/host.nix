{
  lib,
  options,
  ...
}:
{
  options.host = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, ... }:
        let
          nonHostOptions = lib.filterAttrs (
            name: _: if (name == "host" || name == "_module") then false else true
          ) options;
        in
        {
          options = nonHostOptions // {
            name = lib.mkOption {
              type = lib.types.str;
              default = name;
              readOnly = true;
            };
            tags = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
            };
          };
        }
      )
    );
  };
}
