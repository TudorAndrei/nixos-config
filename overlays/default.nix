# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    calf = final.unstable.calf;
    llm = let
      pyWithPackages = final.unstable.python3.withPackages (ps: [
        (final.callPackage ../home-manager/programs/llm/llm-cli {})
        (final.callPackage ../home-manager/programs/llm/llm-gemini {
          inherit (final.unstable) python3;
          unstable = final.unstable;
        })
        (final.callPackage ../home-manager/programs/llm/llm-commit {})
        (final.callPackage ../home-manager/programs/llm/llm-groq {})
      ]);
    in
      prev.runCommandNoCCLocal "llm" {} ''
        mkdir -p $out/bin
        ln -s ${pyWithPackages}/bin/llm $out/bin/llm
      '';
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
