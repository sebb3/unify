{ config, ... }:
{
  unify.hosts.nixos.test = {
    users = {
      quasi = {
        inherit (config.unify.hosts.nixos.test) modules;
        home = {
          home.file.test.text = "test!";
        };
      };
    };
    modules = [
      config.unify.modules.shell
    ];
    displays.DP-1 = {
      primary = true;
      refreshRate = 240;
    };
    nixos = {
      fileSystems."/".device = "/dev/fakeroot";
      boot.loader.grub.devices = [ "/dev/fakeboot" ];
    };
  };
}
