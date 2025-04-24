{ lib, options, ... }:
{
  options = {
    hostOptions = lib.mkOption {
      type = lib.types.attrsOf lib.types.any;
      default = { };
      description = "Additional options for each host";
    };
    host = lib.mkOption {
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
                type = lib.types.listOf lib.types.string;
                default = [ ];
              } // options.hostOptions;
            };
          }
        )
      );
    };
  };
}
