{
  pkgs,
}:
pkgs.buildNpmPackage({
  pname = "foam-language-server";
  version = "0.1.3-unstable-2024-11-10";

  src = pkgs.fetchFromGitHub {
    owner = "FoamScience";
    repo = "foam-language-server";
    rev = "fc0db985a605b5a117eb100c35d9e219f8e5f98f";
    hash = "sha256-V3dl8Q1z8FilAizFd7JpPThefG826qUrwQa6a2OHdvs=";
  };

  npmDepsHash = "sha256-zgfgZpKrx7STawG40rOzWZ0kYtTe3sM/SePHgQHrFOY=";

  nativeBuildInputs = with pkgs; [
    nodejs
    typescript
    python310Full
  ];

  npmBuildHook = ''
  '';

  preInstall = ''
    tsc --build
  '';

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';
})
