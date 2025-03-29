{inputs, ...}: {
  imports = [
    inputs.nixcord.homeManagerModules.nixcord
  ];

  programs.nixcord = {
    enable = false;
    config = {
      themeLinks = [
        "https://raw.githubusercontent.com/KillYoy/DiscordNight/master/DiscordNight.theme.css"
      ];
    };
  };
}
