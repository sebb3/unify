{
  unify.hosts.test = {
    user = "quasi";
    tags = [
      "default"
      "shell"
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
