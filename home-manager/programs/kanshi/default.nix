{...}: {
  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    settings = [
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            scale = 1.0;
            status = "enable";
          }
        ];
      }
      {
        profile.name = "undocked2";
        profile.outputs = [
          {
            criteria = "eDP-2";
            scale = 1.0;
            status = "enable";
          }
        ];
      }
      {
        profile.name = "home";
        profile.outputs = [
          {
            criteria = "LG Electronics LG ULTRAGEAR 0x00023FE9";
            position = "0,0";
            mode = "2560x1080@143.94Hz";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      }
      {
        profile.name = "home2";
        profile.outputs = [
          {
            criteria = "LG Electronics LG ULTRAGEAR 0x00023FE9";
            position = "0,0";
            mode = "2560x1080@143.94Hz";
          }
          {
            criteria = "eDP-2";
            status = "disable";
          }
        ];
      }
    ];
  };
}
