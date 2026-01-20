{inputs, ...}: {
  additions = final: prev: {};
  modifications = final: prev:
    let
      unstable = import inputs.nixpkgs-unstable {
        system = final.system;
        config.allowUnfree = true;
      };
    in
    {
      calf = final.unstable.calf;
      slack = final.unstable.slack.overrideAttrs (oldAttrs: {
        postInstall = (oldAttrs.postInstall or "") + ''
          # Add --disable-gpu flag to the wrapper script
          wrapProgram $out/bin/slack \
            --add-flags "--disable-gpu"
        '';
      });
      fetchPnpmDeps = unstable.fetchPnpmDeps;
    };
    
  # OpenCode overlay to patch the Bun version check
  opencodeOverlay = final: prev: {
    opencode = inputs.opencode.packages.${final.system}.default.overrideAttrs (oldAttrs: {
      # Apply our patch to disable the Bun version check
      patches = (oldAttrs.patches or []) ++ [
        ../patches/opencode/disable-bun-check.patch
      ];
    });
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
