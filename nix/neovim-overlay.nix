# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = import inputs.nixpkgs {
    inherit (final) system;
    config.allowUnfree = true;
  };

  # Use this to create a plugin from a flake input
  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  render-markdown-nvim-custom = pkgs.vimUtils.buildVimPlugin {
    pname = "render-markdown-nvim-custom";
    version = "1.0.0"; # You can set a dummy version
    src = pkgs.fetchFromGitHub {
      owner = "filippo-biondi";
      repo = "render-markdown.nvim";
      rev = "31d86e4992d705dcb098c21455b15682d992d6bf";
      sha256 = "sha256-GR48F5m4s9BVyxdlu+2wHkXCKuY8Kxra76m4zxsO2vI=";
    };
  };

  stay-centered-nvim-custom = pkgs.vimUtils.buildVimPlugin {
    pname = "stay-centered-custom";
    version = "1.0.0"; # You can set a dummy version
    src = pkgs.fetchFromGitHub {
      owner = "filippo-biondi";
      repo = "stay-centered.nvim";
      rev = "af331fd3832bbe7cabf14f4cacc8629ab25fdea5";
      sha256 = "sha256-gsFvoj5cqXMaYf8veBvQCNjW4rbjjnJyAw2gZnl8dCA=";
    };
  };

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix { inherit pkgs; };

  # A plugin can either be a package or an attrset, such as
  # { plugin = <plugin>; # the package, e.g. pkgs.vimPlugins.nvim-cmp
  #   config = <config>; # String; a config that will be loaded with the plugin
  #   # Boolean; Whether to automatically load the plugin as a 'start' plugin,
  #   # or as an 'opt' plugin, that can be loaded with `:packadd!`
  #   optional = <true|false>; # Default: false
  #   ...
  # }
  all-plugins = with pkgs.vimPlugins; [
    # plugins from nixpkgs go in here.
    # https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimPlugins
    catppuccin-nvim
    nvim-web-devicons
    nvim-tree-lua
    nvim-treesitter.withAllGrammars
    nvim-treesitter-parsers.foam
    nvim-treesitter-parsers.python
    nvim-treesitter-parsers.markdown
    nvim-treesitter-parsers.markdown_inline
    nvim-treesitter-parsers.latex
    nvim-treesitter-parsers.html
    nvim-treesitter-parsers.bash
    nvim-treesitter-parsers.lua
    nvim-treesitter-parsers.regex
    nvim-treesitter-parsers.json
    friendly-snippets
    blink-cmp
    lspkind-nvim # vscode-like LSP pictograms | https://github.com/onsails/lspkind.nvim/
    nvim-lspconfig
    nvim-dap
    nvim-dap-ui
    nvim-dap-python
    nvim-dap-virtual-text
    hydra-nvim
    nvim-nio
    noice-nvim
    nui-nvim
    nvim-notify
    # ^ nvim-cmp extensions
    # git integration plugins
    diffview-nvim # https://github.com/sindrets/diffview.nvim/
    neogit # https://github.com/TimUntersberger/neogit/
    gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim/
    vim-fugitive # https://github.com/tpope/vim-fugitive/
    # ^ git integration plugins
    # telescope and extensions
    telescope-nvim # https://github.com/nvim-telescope/telescope.nvim/
    telescope-fzy-native-nvim # https://github.com/nvim-telescope/telescope-fzy-native.nvim
    # telescope-smart-history-nvim # https://github.com/nvim-telescope/telescope-smart-history.nvim
    # ^ telescope and extensions
    # UI
    lualine-nvim # Status line | https://github.com/nvim-lualine/lualine.nvim/
    nvim-navic # Add LSP location to lualine | https://github.com/SmiteshP/nvim-navic
    statuscol-nvim # Status column | https://github.com/luukvbaal/statuscol.nvim/
    nvim-treesitter-context # nvim-treesitter-context
    # ^ UI
    # language support
    # ^ language support
    # navigation/editing enhancement plugins
    vim-unimpaired # predefined ] and [ navigation keymaps | https://github.com/tpope/vim-unimpaired/
    eyeliner-nvim # Highlights unique characters for f/F and t/T motions | https://github.com/jinh0/eyeliner.nvim
    nvim-surround # https://github.com/kylechui/nvim-surround/
    nvim-treesitter-textobjects # https://github.com/nvim-treesitter/nvim-treesitter-textobjects/
    nvim-ts-context-commentstring # https://github.com/joosepalviste/nvim-ts-context-commentstring/
    # ^ navigation/editing enhancement plugins
    todo-comments-nvim
    # Useful utilities
    nvim-unception # Prevent nested neovim sessions | nvim-unception
    # ^ Useful utilities
    # libraries that other plugins depend on
    sqlite-lua
    plenary-nvim
    nvim-web-devicons
    vim-repeat
    # ^ libraries that other plugins depend on
    # bleeding-edge plugins from flake inputs
    # (mkNvimPlugin inputs.wf-nvim "wf.nvim") # (example) keymap hints | https://github.com/Cassin01/wf.nvim
    # ^ bleeding-edge plugins from flake inputs
    which-key-nvim
    copilot-vim
    vimtex
    nvim-lastplace
    # auto-session
    neorg
    nvim-autopairs
    dial-nvim
    vim-better-whitespace
    render-markdown-nvim-custom
    nabla-nvim
    stay-centered-nvim-custom
  ];

  extraPackages = with pkgs; [
    # language servers, etc.
    lua-language-server
    nil # nix LSP
    pyright
    clang-tools
    ripgrep
    fd
    python3Packages.pylatexenc
  ];
in {
  # This is the neovim derivation
  # returned by the overlay
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };

  # This can be symlinked in the devShell's shellHook
  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };

  # You can add as many derivations as you like.
  # Use `ignoreConfigRegexes` to filter out config
  # files you would not like to include.
  #
  # For example:
  #
  # nvim-pkg-no-telescope = mkNeovim {
  #   plugins = [];
  #   ignoreConfigRegexes = [
  #     "^plugin/telescope.lua"
  #     "^ftplugin/.*.lua"
  #   ];
  #   inherit extraPackages;
  # };
}
