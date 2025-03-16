vim.keymap.set('i', '<C-Down>', 'copilot#Accept("<C-Down>")', {
  expr = true,
  replace_keycodes = false
})
vim.keymap.set('i', '<C-End>', 'copilot#AcceptLine("<C-End>")', {
  expr = true,
  replace_keycodes = false
})
vim.keymap.set('i', '<C-Right>', 'copilot#AcceptWord("<C-Right>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true
