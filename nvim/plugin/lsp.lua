vim.lsp.enable('pyright')
vim.lsp.enable('clangd')
vim.lsp.enable('cmake')
vim.lsp.enable('bashls')
vim.lsp.enable('dockerls')
vim.lsp.enable('docker_compose_language_service')
vim.lsp.enable('dts_lsp')
vim.lsp.enable('foam_ls')
vim.lsp.enable('hydra_lsp')
vim.lsp.enable('lua_ls')
vim.lsp.enable('nixd')
vim.lsp.enable('marksman')
vim.lsp.enable('texlab')
vim.lsp.enable('vue_ls')

vim.lsp.config('clangd', {
  cmd = { "clangd", "--clang-tidy" },
})
