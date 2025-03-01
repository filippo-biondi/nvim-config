blink = require('blink.cmp')
blink.setup({
  -- Enable auto-bracket insertion based on semantic tokens
  completion = {
    accept = { auto_brackets = { enabled = true }, },
    menu = {
      draw = {
        -- Specify sources for Treesitter integration
        treesitter = { 'lsp' },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    }
  },
  sources = {
    -- Remove 'buffer' if you don't want text completions, by default it's only enabled when LSP returns no items
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  -- Configure snippet expansion
  snippets = {
    expand = function(snippet, _)
      require('luasnip').lsp_expand(snippet)
    end,
  },
  -- Adjust appearance settings
  appearance = {
    -- Use nvim-cmp's highlight groups as fallback
    use_nvim_cmp_as_default = false,
    -- Set Nerd Font variant ('mono' or 'normal')
    nerd_font_variant = 'normal',
  },
  -- Configure keybindings
  keymap = {
    ['<Up>'] = { 'select_prev', 'fallback' },
    ['<Down>'] = { 'select_next', 'fallback' },
    ['<Tab>'] = { 'accept', 'fallback' },
    ['<C-Up>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-Down>'] = { 'scroll_documentation_down', 'fallback' },
  },
})

local keymap = vim.keymap


