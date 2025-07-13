{...}: {
  services.kanshi = {
    enable = true;
    systemdTarget = "graphical-session.target";
    # systemdTarget = "hyprland-session.target";
    profiles = {
      home_1 = {
        outputs = [
          {
            criteria = "LG Electronics LG ULTRAGEAR 0x00023FE9";
            position = "0,0";
            mode = "2560x1080@60Hz";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      };
      home_2 = {
        outputs = [
          {
            criteria = "LG Electronics LG ULTRAGEAR 0x00023FE9";
            position = "0,0";
            mode = "2560x1080@60Hz";
          }
          {
            criteria = "eDP-2";
            status = "disable";
          }
        ];
      };
      home_bigmonitor = {
        outputs = [
          {
            criteria = "LG Electronics LG TV SSCR2 0x01010101";
            position = "0,0";
            mode = "3840x2160@60.0Hz";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      };
      home_bigmonitor2 = {
        outputs = [
          {
            criteria = "LG Electronics LG TV SSCR2 0x01010101";
            position = "0,0";
            mode = "3840x2160@60.0Hz";
          }
          {
            criteria = "eDP-2";
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
            criteria = "eDP-1";
            scale = 1.0;
            status = "enable";
            position = "1920,0";
          }
        ];
      };
      work2 = {
        outputs = [
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
            position = "1920,0";
          }
        ];
      };
    };
  };
}
