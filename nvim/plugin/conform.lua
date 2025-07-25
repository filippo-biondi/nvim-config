require("conform").setup({
  formatters_by_ft = {
    python = { "black" },
    cpp = { "clang_format" },
  },
})

-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*",
--   callback = function(args)
--     require("conform").format({ bufnr = args.buf })
--   end,
-- })

vim.keymap.set("n", "<leader>cf", function()
  require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
end, { desc = "Format current buffer" })
