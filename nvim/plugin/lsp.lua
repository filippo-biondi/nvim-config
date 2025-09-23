vim.lsp.enable('pyright')
vim.lsp.enable('clangd')
vim.lsp.enable('cmake')
vim.lsp.enable('bashls')
vim.lsp.enable('dockerls')
vim.lsp.enable('docker_compose_language_service')
vim.lsp.enable('dts_lsp')
vim.lsp.enable('lua_ls')
vim.lsp.enable('nixd')
vim.lsp.enable('marksman')
vim.lsp.enable('texlab')

local vue_language_server_path = vim.fs.dirname(vim.fn.exepath("vue-language-server")) ..
"/../lib/language-tools/packages/language-server/node_modules/@vue/typescript-plugin"
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
vim.lsp.enable({'vtsls', 'vue_ls'})


vim.lsp.config('clangd', {
  cmd = { "clangd", "--clang-tidy" },
})
