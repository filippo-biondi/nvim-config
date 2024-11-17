-- if vim.g.did_load_nvim_tree_plugin then
--   return
-- end
-- vim.g.did_load_nvim_tree_plugin = true
-- 
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
