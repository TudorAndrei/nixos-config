{
  config,
  pkgs,
  lib,
  ...
}: {
  options.asus = {
    enable = lib.mkEnableOption "Enable ASUS specific configuration";
  };

  config = lib.mkIf config.asus.enable {
    boot = {
      kernelModules = ["asus-nb-wmi" "asus-wmi" "zenpower"];
      extraModulePackages = with config.boot.kernelPackages; [zenpower];
    };

    services = {
      supergfxd.enable = true;
      asusd = {
        enable = true;
        enableUserService = true;
      };
      acpid = {
        enable = true;
        logEvents = true;
        handlers = {
          brightness-up = {
            event = "video/brightnessup";
            action = "${pkgs.asusctl}/bin/asusctl --brightness-up";
          };
          brightness-down = {
            event = "video/brightnessdown";
            action = "${pkgs.asusctl}/bin/asusctl --brightness-down";
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      asusctl
    ];
  };
}
