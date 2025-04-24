_:
{
  config.host.unify-aux-test = {
    nixos = {
      fileSystems."/".device = "x";
      boot.loader.grub.enable = false;
      environment.etc.nixos-test.text = "testing!";
      users.users.unify = {
        isNormalUser = true;  
        initialPassword = "test";
      };
    };
    home = {
      home.stateVersion = "25.05";
      home.file.home-manager-test.text = "testing!";
    };
  };
}
