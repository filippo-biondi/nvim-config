local stay_centered = require('stay-centered')

stay_centered.setup({ enable = true })
vim.keymap.set({ 'n', 'v' }, '<leader>st', stay_centered.toggle, { desc = 'Toggle stay-centered.nvim' })
