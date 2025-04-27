{
  lib,
  config,
  hostname,
  hostConfig,
}:
{
  options.args = lib.options.create {
    type = lib.types.attrs.any;
    default.value = { };
    description = "Values added to this attribute set will be available as module arguments.";
  };

  config = {
    __module__.args.dynamic =
      let
        host = lib.attrs.select [ hostname ] config.host;
        homeConfig = config.home;
        osConfig =
          if hostConfig.type == "nixos" then
            config.nixos
          else if hostConfig.type == "darwin" then
            config.darwin
          else if hostConfig.type == "system-manager" then
            config.system
          else
            { };
      in
      {
        inherit
          host
          osConfig
          homeConfig
          ;
      }
      // config.args;
  };
}
