# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: prev: import ../pkgs { pkgs = prev; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    calf = final.unstable.calf;
    llm = prev.python3.withPackages (ps: with ps; [
      final.llm-cli
      final.llm-commit
      final.llm-gemini
      final.llm-groq
    ]);
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
