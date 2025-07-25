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

  # hydra = pkgs.vimUtils.buildVimPlugin {
  #   pname = "hydra.nvim";
  #   version = "2025-05-04";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "nvimtools";
  #     repo = "hydra.nvim";
  #     rev = "8c4a9f621ec7cdc30411a1f3b6d5eebb12b469dc";
  #     sha256 = "sha256-lYwl4wrVsCq1JVbkDyq1lB1hBGrz+XtQ9DQWIQ6lkyg=";
  #   };
  #   meta.homepage = "https://github.com/nvimtools/hydra.nvim/";
  #   meta.hydraPlatforms = [ ];
  # };

  # nvim-dap-view = pkgs.vimUtils.buildVimPlugin {
  #   pname = "nvim-dap-view";
  #   version = "2025-05-16";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "igorlfs";
  #     repo = "nvim-dap-view";
  #     rev = "d76741a718a551125f2556f63f6757916291706d";
  #     sha256 = "sha256-ytFvjvIYno5oPsZsCexvhLs4WF189NBhids+h/Nksns=";
  #   };
  #   doCheck = false;
  # };

  # hardtime-nvim = pkgs.vimUtils.buildVimPlugin rec {
  #   pname = "hardtime.nvim";
  #   version = "1.0.0";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "m4xshen";
  #     repo = "hardtime.nvim";
  #     rev = "v${version}";
  #     sha256 = "sha256-ureji2SAdHFxxBkLx9nN0PLH+7Q8AOO4OdMbUKuZby8=";
  #   };
  # };
}
