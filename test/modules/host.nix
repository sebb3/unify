{ config, ... }:
{
  unify.hosts.nixos.test = {
    users.quasi.modules = config.unify.hosts.nixos.test.modules;
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
