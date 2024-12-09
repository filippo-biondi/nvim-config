local Hydra = require('hydra')

local hydra_statusline = require("hydra.statusline")
local dapui = require("dapui")
local dap = require("dap")

DapHydra = Hydra({
   name = "DEBUG",
   config = {
      desc = "Debug mode",
      invoke_on_body = true,
   },

   mode = 'n',
   body = '<leader>d',
   heads = {
      { "U", function() require("dapui").toggle() end},
      { "z", function() require("dap").toggle_breakpoint() end },
      { "Z", function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end },
      { ">", function() if vim.bo.filetype ~= "dap-float" then require("dap").continue() end end},
      { "K", function() if vim.bo.filetype ~= "dap-float" then require("dap").step_back() end end},
      { "H", function() if vim.bo.filetype ~= "dap-float" then require("dap").step_out() end end},
      { "J", function() if vim.bo.filetype ~= "dap-float" then print(vim.bo.filetype) require("dap").step_over() end end},
      { "L", function() if vim.bo.filetype ~= "dap-float" then require("dap").step_into() end end},
      -- { "gl", function() debug_run_last() end},
      { "X", function() require("dap").terminate() end},
      { "*", function() require("dap").run_to_cursor() end},
      { "s", function() if vim.bo.filetype ~= "dap-float" then require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes) end end},
      { "g?", function() if DapHydra.hint.win then DapHydra.hint:close() else DapHydra.hint:show() end end},
      { '<Esc>', nil, { exit = true, nowait = true } },
   }
})
