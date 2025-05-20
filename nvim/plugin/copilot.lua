if vim.g.did_load_copilot_plugin then
  return
end
vim.g.did_load_copilot_plugin = true

vim.keymap.set('i', '<S-Down>', 'copilot#Accept("<S-Down>")', {
  expr = true,
  replace_keycodes = false,
  silent = true
})
vim.keymap.set('i', '<S-End>', 'copilot#AcceptLine("<S-End>")', {
  expr = true,
  replace_keycodes = false,
  silent = true
})
vim.keymap.set('i', '<S-Right>', 'copilot#AcceptWord("<S-Right>")', {
  expr = true,
  replace_keycodes = false,
  silent = true
})
vim.g.copilot_no_tab_map = true
