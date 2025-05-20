# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = import inputs.nixpkgs {
    inherit (final) system;
    config.allowUnfree = true;
  };

  custom-pkgs = import ./custom-pkgs { inherit pkgs; };

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
    nvim-treesitter-context
    nvim-treesitter-textobjects
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
    nvim-treesitter-parsers.dockerfile
    nvim-treesitter-parsers.devicetree
    friendly-snippets
    blink-cmp
    blink-compat
    lspkind-nvim # vscode-like LSP pictograms | https://github.com/onsails/lspkind.nvim/
    nvim-lspconfig
    nvim-dap
    nvim-dap-python
    custom-pkgs.nvim-dap-view
    nvim-dap-virtual-text
    custom-pkgs.hydra
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
    telescope-smart-history-nvim # https://github.com/nvim-telescope/telescope-smart-history.nvim
    # ^ telescope and extensions
    # UI
    lualine-nvim # Status line | https://github.com/nvim-lualine/lualine.nvim/
    nvim-navic # Add LSP location to lualine | https://github.com/SmiteshP/nvim-navic
    statuscol-nvim # Status column | https://github.com/luukvbaal/statuscol.nvim/
    # ^ UI
    # language support
    # ^ language support
    # navigation/editing enhancement plugins
    vim-unimpaired # predefined ] and [ navigation keymaps | https://github.com/tpope/vim-unimpaired/
    nvim-surround # https://github.com/kylechui/nvim-surround/
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
    which-key-nvim
    copilot-vim
    vimtex
    nvim-lastplace
    # auto-session
    neorg
    nvim-autopairs
    dial-nvim
    vim-better-whitespace
    render-markdown-nvim
    nabla-nvim
    custom-pkgs.stay-centered-nvim
    auto-save-nvim
    nvim-osc52
    nvim-colorizer-lua
    cmp-dap
    nvim-cmp
    leap-nvim
    custom-pkgs.hardtime-nvim
    bufferline-nvim
  ];

  extraPackages = with pkgs; [
    # language servers, etc.
    lua-language-server
    nixd
    pyright
    clang-tools
    cmake-language-server
    ripgrep
    fd
    python3Packages.pylatexenc
    nerd-fonts.jetbrains-mono
    bash-language-server
    dockerfile-language-server-nodejs
    docker-compose-language-service
    custom-pkgs.foam-lsp
    custom-pkgs.hydra-lsp
    custom-pkgs.dts-lsp
    marksman
    systemd-language-server
    texlab
    sqlite
  ];

in {
  # This is the neovim derivation
  # returned by the overlay
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };

  # This is meant to be used within a devshell.
  # Instead of loading the lua Neovim configuration from
  # the Nix store, it is loaded from $XDG_CONFIG_HOME/nvim-dev
  nvim-dev = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
    appName = "nvim-dev";
    wrapRc = false;
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
