vim.keymap.set('i', '<C-Right>', 'copilot#AcceptLine("<C-Right>")', {
  expr = true,
  replace_keycodes = false
})
vim.keymap.set('i', '<Right>', 'copilot#AcceptWord("<Right>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true
