if vim.g.did_load_leap_plugin then
  return
end
vim.g.did_load_leap_plugin = true

vim.keymap.set({'n', 'x', 'o'}, 'l', '<Plug>(leap)')
vim.keymap.set('n',             'L', '<Plug>(leap-from-window)')
