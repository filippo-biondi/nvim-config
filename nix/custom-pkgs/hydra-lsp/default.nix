{
  pkgs
}: let
  customPythonPackages = pkgs.python312.pkgs.overrideScope (self: super: {
    ruamel-yaml = super."ruamel-yaml".overridePythonAttrs (old: {
      version = "0.17.40";
      src = pkgs.fetchPypi {
        pname = "ruamel.yaml";
        version = "0.17.40";
        sha256 = "sha256-YCS5hvBnZdSCtbB+CGzEtM0F3SLdy8dY+iPVSHPPMT0=";
      };
    });
    importlib-metadata = super."importlib-metadata".overridePythonAttrs (old: {
      version = "6.11.0";
      src = pkgs.fetchPypi {
        pname = "importlib_metadata";
        version = "6.11.0";
        sha256 = "sha256-EjHPktglyeA8/E2gdqFt5kIshjVYIp6gsitnVldGNEM=";
      };
    });
  });
in customPythonPackages.buildPythonApplication {
  pname = "hydra-lsp";
  version = "0.1.3";
  pyproject = true;
  src = pkgs.fetchFromGitHub {
    owner = "Retsediv";
    repo = "hydra-lsp";
    rev = "d9009305a211e2c9932be6c097878252823cdc91";
    sha256 = "sha256-4xY3E15lpuZxXXS0NyLwen+ot38RZ+a4A0BDfg6XpH4=";
  };
  build-system = with customPythonPackages; [
    poetry-core
  ];

  nativeBuildInputs = with customPythonPackages; [
    poetry-core
  ];

  propagatedBuildInputs = with customPythonPackages; [
    importlib-metadata
    intervaltree
    lsprotocol
    pygls
    pygtrie
    ruamel-yaml
  ];
}
