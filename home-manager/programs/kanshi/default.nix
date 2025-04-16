_: {
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
        profile.name = "home-bigmonitor";
        profile.outputs = [
          {
            criteria = "LG Electronics LG TV SSCR2 0x01010101";
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
      {
        profile.name = "work";
        profile.outputs = [
          {
            criteria = "Dell Inc. DELL U4320Q 41LFCH3";
            position = "0,0";
            mode = "3840x2160@60Hz";
            scale = 2.0;
          }
          {
            criteria = "eDP-1";
            scale = 1.0;
            status = "enable";
            position = "2160@,0";
          }
        ];
      }
      {
        profile.name = "work2";
        profile.outputs = [
          {
            criteria = "Dell Inc. DELL U4320Q 41LFCH3";
            position = "0,0";
            mode = "3840x2160@60Hz";
            scale = 2.0;
          }
          {
            criteria = "eDP-2";
            scale = 1.0;
            status = "enable";
            position = "2160@,0";
          }
        ];
      }
    ];
  };
}
