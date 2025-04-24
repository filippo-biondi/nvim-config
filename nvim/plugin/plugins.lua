if vim.g.did_load_plugins_plugin then
  return
end
vim.g.did_load_plugins_plugin = true

-- many plugins annoyingly require a call to a 'setup' function to be loaded,
-- even with default configs

require('nvim-surround').setup()
require("dap-python").setup("python3")
require("dapui").setup()
require("nvim-dap-virtual-text").setup()
require("nvim-lastplace").setup()
-- require("auto-session").setup {
--       suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
-- }

require("nvim-autopairs").setup()
require("auto-save").setup()
require('osc52').setup()

