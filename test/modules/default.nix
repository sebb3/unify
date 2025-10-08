{
  unify = {
    nixos = {
      system.stateVersion = "22.05";
      nixpkgs.hostPlatform = "x86_64-linux";
      users.users.quasi = {
        isNormalUser = true;
        initialPassword = "test";
      };
    };
    home = {
      home.stateVersion = "22.05";
    };
    darwin = {
        system.stateVersion = 6;
    };
    modules.shell = {
      darwin.programs.fish.enable = true;
      home.programs = {
        fish.enable = true;
        bat.enable = true;
      };
    };
  };
}
