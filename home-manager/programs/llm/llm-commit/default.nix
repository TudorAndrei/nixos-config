{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "llm-commit";
  version = "0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gntousakis";
    repo = "llm-commit";
    rev = version;
    hash = "sha256-aFOEWsxlb7eR5hG3NgxOsonG5aN1/I6tp855XJTBgOk=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = [
    python3.pkgs.llm
    python3.pkgs.httpx
  ];

  pythonImportsCheck = ["llm_commit"];

  meta = with lib; {
    description = "A plugin for llm that generates commit messages ";
    homepage = "https://github.com/gntousakis/llm-commit";
    license = licenses.asl20;
    maintainers = with maintainers; [];
    mainProgram = "llm-commit";
  };
}
