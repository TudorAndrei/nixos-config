{
  lib,
  python3,
  fetchFromGitHub,
  unstable,
}:
unstable.python3Packages.buildPythonPackage rec {
  pname = "llm-cli";
  version = "0.23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm";
    rev = version;
    hash = "sha256-jUWhdLZLHgrIP7trHvLBETQ764+k4ze5Swt2HYMqg4E=";
  };

  nativeBuildInputs = with unstable.python3Packages; [
    click-default-group
    numpy
    openai
    pip
    pluggy
    puremagic
    pydantic
    python-ulid
    pyyaml
    setuptools # for pkg_resources
    sqlite-migrate
    sqlite-utils
  ];

  pythonImportsCheck = ["llm"];

  meta = with lib; {
    description = "";
    homepage = "";
    license = licenses.asl20;
    maintainers = with maintainers; [];
    mainProgram = "llm";
  };
}
