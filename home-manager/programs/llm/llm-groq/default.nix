{
  lib,
  python3,
  fetchFromGitHub,
  unstable,
}:
unstable.python3Packages.buildPythonPackage rec {
  pname = "llm-groq";
  version = "0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angerman";
    repo = "llm-groq";
    rev = version;
    hash = "sha256-sZ5d9w43NvypaPrebwZ5BLgRaCHAhd7gBU6uHEdUaF4=";
  };

  nativeBuildInputs = with unstable.python3Packages; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with unstable.python3Packages; [
    llm
    groq
  ];

  pythonImportsCheck = ["llm_groq"];

  meta = with lib; {
    description = "LLM plugin to access groq family of models";
    homepage = "https://github.com/angerman/llm-groq";
    license = licenses.asl20;
    maintainers = with maintainers; [];
    mainProgram = "llm-groq";
  };
}
