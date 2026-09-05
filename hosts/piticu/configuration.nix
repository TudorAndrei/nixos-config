_: {
  imports = [
    ../common-darwin.nix
    ../modules/homebrew
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  networking = {
    hostName = "piticu";
    computerName = "piticu";
    localHostName = "piticu";
  };

  system.primaryUser = "tudor";

  users.users.tudor = {
    name = "tudor";
    home = "/Users/tudor";
  };
}
