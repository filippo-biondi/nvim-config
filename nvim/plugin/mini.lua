if vim.g.did_load_mini_plugin then
  return
end
vim.g.did_load_mini_plugin = true

require('mini.move').setup({
  mappings = {
    left = "<C-S-Left>",
    right = "<C-S-Right>",
    down = "<C-S-Down>",
    up = "<C-S-Up>",

    line_left = "<C-S-Left>",
    line_right = "<C-S-Right>",
    line_down = "<C-S-Down>",
    line_up = "<C-S-Up>",
  },
})

require('mini.pairs').setup()
require('mini.splitjoin').setup()
require('mini.surround').setup()
require('mini.bufremove').setup()
require('mini.cursorword').setup()
require('mini.icons').setup()
require('mini.trailspace').setup()

vim.keymap.set('n', '<leader>rt', function() MiniTrailspace.trim() end, { desc = '[r]emove [t]railing spaces' })

require('mini.indentscope').setup({
  draw = {
    delay = 100,
    animation = require('mini.indentscope').gen_animation.none(),
  },
  options = {
    try_as_border = true,
  },
})

vim.api.nvim_create_autocmd({ "FileType" }, {
        desc = "Disable indentscope for certain filetypes",
        callback = function()
          local ignore_filetypes = {
            "aerial",
            "dashboard",
            "help",
            "lazy",
            "leetcode.nvim",
            "mason",
            "neo-tree",
            "NvimTree",
            "neogitstatus",
            "notify",
            "startify",
            "toggleterm",
            "Trouble"
          }
          if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
            vim.b.miniindentscope_disable = true
          end
        end,
      })
