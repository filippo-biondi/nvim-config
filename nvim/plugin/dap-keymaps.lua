local Hydra = require('hydra')

DapHydra = Hydra({
   name = "DEBUG",
   config = {
      desc = "Debug mode",
      color = "pink",
      hint = false,
      on_enter = function () require("lualine").refresh() end,
      on_exit = function () require("lualine").refresh() end,
   },
   mode = 'n',
   body = '<leader>d',
   heads = {
      { "U", function() require("dapui").toggle() end},
      { "s", function() require("dap").toggle_breakpoint() end },
     -- { "S", function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end },
      { "h", function() if vim.bo.filetype ~= "dap-float" then require("dap").continue() end end},
     -- { "H", function() if vim.bo.filetype ~= "dap-float" then require("dap").step_back() end end},
      { "t", function() if vim.bo.filetype ~= "dap-float" then require("dap").step_out() end end},
      { "a", function() if vim.bo.filetype ~= "dap-float" then print(vim.bo.filetype) require("dap").step_over() end end},
      { ",", function() if vim.bo.filetype ~= "dap-float" then require("dap").step_into() end end},
      -- { "gl", function() debug_run_last() end},
      { "X", function() require("dap").terminate() end},
      { "*", function() require("dap").run_to_cursor() end},
      { "m", function() if vim.bo.filetype ~= "dap-float" then require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes) end end},
      { "g?", function() if DapHydra.hint.win then DapHydra.hint:close() else DapHydra.hint:show() end end},
      { '<Esc>', nil, { exit = true, nowait = true } },
   }
})
