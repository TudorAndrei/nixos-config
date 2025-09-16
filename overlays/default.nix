{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: prev: {};

  # # This one contains whatever you want to overlay
  # # You can change versions, add patches, set compilation flags, anything really.
  # # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    calf = final.unstable.calf;
    slack = final.unstable.slack.overrideAttrs (oldAttrs: {
      postInstall = (oldAttrs.postInstall or "") + ''
        # Add --disable-gpu flag to the wrapper script
        wrapProgram $out/bin/slack \
          --add-flags "--disable-gpu"
      '';
    });
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
