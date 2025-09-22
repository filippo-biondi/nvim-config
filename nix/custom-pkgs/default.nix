{
  pkgs
}: {
  dts-lsp = import ./dts-lsp { inherit pkgs; };

  stay-centered-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "stay-centered-custom";
    version = "1.0.0"; # You can set a dummy version
    src = pkgs.fetchFromGitHub {
      owner = "filippo-biondi";
      repo = "stay-centered.nvim";
      rev = "af331fd3832bbe7cabf14f4cacc8629ab25fdea5";
      sha256 = "sha256-gsFvoj5cqXMaYf8veBvQCNjW4rbjjnJyAw2gZnl8dCA=";
    };
  };

  gemini-cli-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "gemini-cli-nvim";
    version = "1.2.0";
    src = pkgs.fetchFromGitHub {
      owner = "JonRoosevelt";
      repo = "gemini-cli.nvim";
      rev = "887fc46979e0a1e4e05035bcc83deb76164e91a2";
      sha256 = "sha256-47qd9kHXyUFfgCePwYHZ4GwvezOhLfbYcy57OpMYlQU=";
    };
  };
}
