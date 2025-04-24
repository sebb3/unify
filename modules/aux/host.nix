{ lib, options }:
{
  options = {
    hostOptions = lib.options.create {
      type = lib.types.attrs.any;
      default = { };
      description = "Additional options for each host";
    };
    host = lib.options.create {
      type = lib.types.attrs.of (
        lib.types.submodule (
          { name }:
          let
            nonHostOptions = lib.attrs.filter (
              name: _: if (name == "host" || name == "__module__") then false else true
            ) options;
          in
          {
            options = nonHostOptions // {
              name = lib.options.create {
                type = lib.types.string;
                default.value = name;
                writable = false;
              };
              tags = lib.options.create {
                type = lib.types.list.of lib.types.string;
                default.value = [ ];
              };
            } // options.hostOptions;
          }
        )
      );
    };
  };
}
