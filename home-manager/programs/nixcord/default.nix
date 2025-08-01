{inputs, ...}: {
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];

  programs.nixcord = {
    enable = true;
    vesktop.enable = true;
    config = {
      themeLinks = [
        "https://raw.githubusercontent.com/KillYoy/DiscordNight/master/DiscordNight.theme.css"
      ];
    };
  };
}
