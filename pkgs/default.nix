pkgs: {
  jan = pkgs.callPackage ./jan.nix { };
  opencode = pkgs.callPackage ./opencode.nix { };
  llm-cli = pkgs.callPackage ./llm/llm-cli { };
  llm-commit = pkgs.callPackage ./llm/llm-commit { };
  llm-gemini = pkgs.callPackage ./llm/llm-gemini { };
  llm-groq = pkgs.callPackage ./llm/llm-groq { };
}
