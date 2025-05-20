if vim.g.did_load_dap_plugin then
  return
end
vim.g.did_load_dap_plugin = true

require("dap-python").setup("python3")

local dap = require("dap")
local dap_view = require("dap-view")

dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}

dap.configurations.c = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = "Select and attach to process",
    type = "gdb",
    request = "attach",
    program = function()
       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    pid = function()
       local name = vim.fn.input('Executable name (filter): ')
       return require("dap.utils").pick_process({ filter = name })
    end,
    cwd = '${workspaceFolder}'
  }
}


vim.fn.sign_define('DapBreakpoint', {
  text = '🔴',
  texthl = 'DapBreakpoint',
  linehl = '',
  numhl = ''
})

vim.fn.sign_define('DapBreakpointCondition', {
  text = '🟠',
  texthl = 'DapBreakpointCondition',
  linehl = '',
  numhl = ''
})

vim.fn.sign_define('DapBreakpointRejected', {
  text = '🚫',
  texthl = 'DapBreakpointRejected',
  linehl = '',
  numhl = ''
})

vim.fn.sign_define('DapLogPoint', {
  -- square sign
  text = '🔵',
  texthl = 'DapLogPoint',
  linehl = '',
  numhl = ''
})

vim.fn.sign_define('DapStopped', {
  text = '➜',
  texthl = 'DapStopped',
  linehl = 'DebugLine',   -- You can define DebugLine if you want to highlight the entire line
  numhl = ''
})

vim.cmd [[
  highlight DapStopped guifg=#ff0000 guibg=NONE
  highlight DebugLine guibg=#000000
]]


-- Cut max length of display string
require("nvim-dap-virtual-text").setup({
  highlight_new_as_changed = false,
  only_first_definition = false,
  all_references = false,
  display_callback = function(variable, buf, stackframe, node, options)
      local max_len = 40
      local value_str = variable.value:gsub("%s+", " ")
      local display

      if options.virt_text_pos == 'inline' then
        display = ' = ' .. value_str
      else
        display = variable.name .. ' = ' .. value_str
      end

      if #display > max_len then
        display = display:sub(1, max_len - 3) .. "..."
      end

      return display
    end,
})
