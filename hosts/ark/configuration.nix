{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common.nix
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
  };

  boot = {
    kernelParams = ["btusb.enable_autosuspend=n"];
    plymouth = {
      enable = true;
      theme = "rings";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = ["rings"];
        })
      ];
    };
  };

  networking.hostName = "ark";

  users.users.tudor.extraGroups = [
    "video"
    "networkmanager"
    "kvm"
    "wheel"
    "audio"
    "docker"
  ];

  hardware.bluetooth.settings.General = {
    Enable = "Source,Sink,Media,Socket";
    ControllerMode = "bredr";
  };

  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-media-driver
      nvidia-vaapi-driver
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [intel-vaapi-driver];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    # powerManagement.finegrained = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    forceFullCompositionPipeline = true;
    prime = {
      # offload = {
      #   enable = true;
      #   enableOffloadCmd = lib.mkIf config.hardware.nvidia.prime.offload.enable true; # Provides `nvidia-offload` command.
      # };
      sync.enable = true;
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  };

  virtualisation.waydroid.enable = true;

  services = {
    devmon.enable = true;
    udisks2.enable = true;
  };

  environment.systemPackages = with pkgs; [
    mcontrolcenter
  ];

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  system.stateVersion = "24.11"; 
}
