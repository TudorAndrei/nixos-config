{...}: {
  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    settings = [
      {
        profile = {
          name = "laptop-only";
          outputs = [
            {
              criteria = "BOE NE173QHM-NZ2";
              status = "enable";
              mode = "2560x1440@240.00Hz";
              scale = 1.0;
            }
          ];
        };
      }
      {
        profile = {
          name = "home_monitor";
          outputs = [
            {
              criteria = "LG Electronics LG ULTRAGEAR 0x00023FE9";
              status = "enable";
              mode = "2560x1080@60Hz";
              position = "2560,0";
            }
            {
              criteria = "BOE NE173QHM-NZ2";
              status = "enable";
              position = "0,0";
              scale = 1.0;
            }
          ];
        };
      }
      {
        profile.name = "home_tv";
        profile.outputs = [
          {
            criteria = "LG Electronics LG TV SSCR2 0x01010101";
            position = "0,0";
            mode = "3840x2160@60.0";
          }
          {
            criteria = "BOE NE173QHM-NZ2";
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
            mode = "3840x2160@60";
            scale = 2.0;
          }
          {
            criteria = "BOE NE173QHM-NZ2";
            scale = 1.0;
            status = "enable";
            position = "1920,0";
          }
        ];
      }
    ];
  };
}
