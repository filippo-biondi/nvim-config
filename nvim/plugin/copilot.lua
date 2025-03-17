vim.keymap.set('i', '<S-Down>', 'copilot#Accept("<S-Down>")', {
  expr = true,
  replace_keycodes = false
})
vim.keymap.set('i', '<S-End>', 'copilot#AcceptLine("<S-End>")', {
  expr = true,
  replace_keycodes = false
})
vim.keymap.set('i', '<S-Right>', 'copilot#AcceptWord("<S-Right>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true
