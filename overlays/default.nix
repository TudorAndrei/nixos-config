{inputs, ...}: {
  additions = final: prev: {};
  modifications = final: prev: let
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  in {
    calf = final.unstable.calf;
    slack = final.unstable.slack.overrideAttrs (oldAttrs: {
      postInstall =
        (oldAttrs.postInstall or "")
        + ''
          # Add --disable-gpu flag to the wrapper script
          wrapProgram $out/bin/slack \
            --add-flags "--disable-gpu"
        '';
    });
    fetchPnpmDeps = unstable.fetchPnpmDeps;
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
