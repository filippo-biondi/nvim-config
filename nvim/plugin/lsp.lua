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

local vue_language_server_path = vim.fn.system("dirname $(which vue-language-server)"):gsub('%\n$', '') .. "/../lib/node_modules/@vue/language-server"
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}
local vtsls_config = {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
  },
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }
}

vim.lsp.config('vtsls', vtsls_config)
vim.lsp.enable('vtsls')


vim.lsp.config('clangd', {
  cmd = { "clangd", "--clang-tidy" },
})
