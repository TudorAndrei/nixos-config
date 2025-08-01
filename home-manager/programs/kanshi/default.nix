{...}: {
  services.kanshi = {
    enable = false;
    systemdTarget = "graphical-session.target";
    # systemdTarget = "hyprland-session.target";
    profiles = {
      home_monitor = {
        outputs = [
          {
            criteria = "LG Electronics LG ULTRAGEAR 0x00023FE9";
            mode = "2560x1080@60Hz";
            position = "0,0";
          }
          {
            criteria = "BOE NE173QHM-NZ2";
          }
        ];
      };
      home_tv = {
        outputs = [
          {
            criteria = "LG Electronics LG TV SSCR2 0x01010101";
            position = "0,0";
            mode = "3840x2160@60.0Hz";
          }
          {
            criteria = "BOE NE173QHM-NZ2";
            status = "disable";
          }
        ];
      };
      work = {
        outputs = [
          {
            criteria = "Dell Inc. DELL U4320Q 41LFCH3";
            position = "0,0";
            mode = "3840x2160@60Hz";
            scale = 2.0;
          }
          {
            criteria = "BOE NE173QHM-NZ2";
            scale = 1.0;
            status = "enable";
            position = "1920,0";
          }
        ];
      };
    };
  };
}
