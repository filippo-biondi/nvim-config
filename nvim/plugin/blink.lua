if vim.g.did_load_blink_plugin then
  return
end
vim.g.did_load_blink_plugin = true

local blink = require('blink.cmp')

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
    default = function ()
      if require("cmp_dap").is_dap_buffer() then
        return { 'dap', 'lsp', 'path', 'snippets', 'buffer' }
      else
        return { 'lsp', 'path', 'snippets', 'buffer' }
      end
    end,
    providers = {
      dap = {
        name = "dap",
        module = "blink.compat.source",
      },
    },
  },
  appearance = {
    -- Use nvim-cmp's highlight groups as fallback
    use_nvim_cmp_as_default = false,
    -- Set Nerd Font variant ('mono' or 'normal')
    nerd_font_variant = 'normal',
  },
  signature = {
    enabled = true,
    window = {
      show_documentation = false,
    },
  },
  -- Configure keybindings
  keymap = {
    ['<Up>'] = { 'select_prev', 'fallback' },
    ['<Down>'] = { 'select_next', 'fallback' },
    ['<Tab>'] = { 'accept', 'fallback' },
    ['<C-Up>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-S>'] = { 'show', 'hide' },
    ['<C-Down>'] = { 'scroll_documentation_down', 'fallback' },
    ['<C-H>'] = { 'show_documentation', 'hide_documentation', 'fallback' },
    ['<C-N>'] = { 'snippet_forward', 'fallback' },
    ['<C-B>'] = { 'snippet_backward', 'fallback' },
  },

  cmdline = {
    keymap = { preset = 'inherit' },
    completion = { menu = { auto_show = true } },
  },
})
