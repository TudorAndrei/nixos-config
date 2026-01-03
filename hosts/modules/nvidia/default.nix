{
  config,
  lib,
  pkgs,
  ...
}: {
  options.nvidia = {
    enable = lib.mkEnableOption "nvidia GPU configuration";

    prime = {
      mode = lib.mkOption {
        type = lib.types.enum ["offload" "sync"];
        description = "PRIME render mode";
      };

      nvidiaBusId = lib.mkOption {
        type = lib.types.str;
        description = "PCI bus ID of the NVIDIA GPU";
      };

      intelBusId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "PCI bus ID of the Intel GPU";
      };

      amdBusId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "PCI bus ID of the AMD GPU";
      };
    };

    powerManagement = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable NVIDIA power management";
      };
    };
  };

  config = lib.mkIf config.nvidia.enable {
    services.xserver.videoDrivers = ["nvidia"];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      package = pkgs.mesa;
      package32 = pkgs.pkgsi686Linux.mesa;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
      ];
    };

    hardware.nvidia-container-toolkit.enable = true;

    hardware.nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      powerManagement.enable = config.nvidia.powerManagement.enable;

      prime = lib.mkMerge [
        {
          nvidiaBusId = config.nvidia.prime.nvidiaBusId;
        }

        (lib.mkIf (config.nvidia.prime.intelBusId != null) {
          intelBusId = config.nvidia.prime.intelBusId;
        })

        (lib.mkIf (config.nvidia.prime.amdBusId != null) {
          amdgpuBusId = config.nvidia.prime.amdBusId;
        })

        (lib.mkIf (config.nvidia.prime.mode == "offload") {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
        })

        (lib.mkIf (config.nvidia.prime.mode == "sync") {
          sync.enable = true;
        })
      ];
    };

    environment.sessionVariables = {
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia";
    };
  };
}

