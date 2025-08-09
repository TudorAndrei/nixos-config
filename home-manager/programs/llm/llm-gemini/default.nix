{
  lib,
  python3,
  fetchFromGitHub,
  unstable,
}:
unstable.python3Packages.buildPythonPackage rec {
  pname = "llm-gemini";
  version = "0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-gemini";
    rev = version;
    # hash = "sha256-ejZIClYRKyL68LFMjshLYLuaP7qK9mHqoKtfXwBN01U=";
    hash = "sha256-I6rjhQYfehOfZoEMbP1W8/Wu2Mzx43VHWV4BOeW3HFw=";
  };

  nativeBuildInputs = with unstable.python3Packages; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with unstable.python3Packages; [
    httpx
    ijson
    llm
  ];

  pythonImportsCheck = ["llm_gemini"];

  meta = with lib; {
    description = "LLM plugin to access Google's Gemini family of models";
    homepage = "https://github.com/simonw/llm-gemini";
    license = licenses.asl20;
    maintainers = with maintainers; [];
    mainProgram = "llm-gemini";
  };
}
