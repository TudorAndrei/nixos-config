{
  fetchFromGitHub,
  lib,
  pkgs,
  buildGo124Module,
}:
buildGo124Module {
  pname = "opencode";
  version = "0.0.49";
  src = fetchFromGitHub {
    owner = "opencode-ai";
    repo = "opencode";
    tag = "v0.0.46";
    hash = "sha256-Q7ArUsFMpe0zayUMBJd+fC1K4jTGElIFep31Qa/L1jY=";
  };
  vendorHash = "sha256-MVpluFTF/2S6tRQQAXE3ujskQZ3njBkfve0RQgk3IkQ=";
  nativeBuildInputs = [pkgs.fzf pkgs.ripgrep];
  meta = {
    description = "Simple command-line snippet manager, written in Go";
    homepage = "https://github.com/opencode-ai/opencode";
    license = lib.licenses.mit;
    maintainers = [];
  };
  doCheck = false;
}
