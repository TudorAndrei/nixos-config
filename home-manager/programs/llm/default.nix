{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    (pkgs.callPackage ./llm-cli {})
    (pkgs.callPackage ./llm-commit {})
    (pkgs.callPackage ./llm-gemini {})
    (pkgs.callPackage ./llm-groq {})
  ];
}