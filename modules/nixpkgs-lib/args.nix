{
  lib,
  config,
  hostname,
  hostConfig,
  ...
}:
{
  options.args = lib.mkOption {
    type = lib.types.attrs;
    default = { };
    description = "Values added to this attribute set will be available as module arguments.";
  };

  config = {
    _module.args =
      let
        host = lib.attrsets.attrByPath [ hostname ] config.host;
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
      } // config.args;
  };
}
