{
  fetchFromGitHub,
  lib,
  pkgs,
  buildGo124Module,
}:
buildGo124Module {
  pname = "opencode";
  version = "0.0.46";
  src = fetchFromGitHub {
    owner = "opencode-ai";
    repo = "opencode";
    tag = "v0.0.46";
    hash = "sha256-PQuv3XX6aGs5XeuIYnQlTHqPFbJDg1WO6BWEuwbqjY4=";
  };
  vendorHash = "sha256-0Gfn3G4ar6lHJk5SnR5dkHD0XeYi7Te6T00b5MwXKTk=";
  nativeBuildInputs = [pkgs.fzf pkgs.ripgrep];
  meta = {
    description = "Simple command-line snippet manager, written in Go";
    homepage = "https://github.com/opencode-ai/opencode";
    license = lib.licenses.mit;
    maintainers = [];
  };
  doCheck = false;
}
