require("hardtime").setup({
  max_count = 5,
  disable_mouse = false,
  disabled_keys = {
    ["<Up>"] = false,
    ["<Down>"] = false,
    ["<Left>"] = false,
    ["<Right>"] = false,
  },

  restricted_keys = {
    ["<Up>"] = { "n", "x" },
    ["<Down>"] = { "n", "x" },
    ["<Left>"] = { "n", "x" },
    ["<Right>"] = { "n", "x" },
   },
  hints = {
    ["d<End>"] = {
      message = function()
        return "Use D instead of d<End>"
      end,
      length = 6,
    },
    ["<End>a"] = {
       message = function()
          return "Use A instead of <End>a"
       end,
       length = 6,
    },
    ["y<End>"] = {
       message = function()
          return "Use Y instead of y<End>"
       end,
       length = 6,
    },
    ["c<End>"] = {
      message = function()
        return "Use C instead of c<End>"
      end,
      length = 6,
    },
    ["%^i"] = {
      message = function()
        return "Use I instead of ^i"
      end,
      length = 2,
    },
  },
})

vim.keymap.set("n", "<leader>ht", function()
  require("hardtime").toggle()
end, { desc = "Toggle Hardtime" })
