if vim.g.did_load_dap_keymap_plugin then
  return
end
vim.g.did_load_dap_keymap_plugin = true

local Hydra = require('hydra')
local lualine = require('lualine')

local dap = require("dap")
local dap_view = require("dap-view")
local dap_virtual_text = require("nvim-dap-virtual-text")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "dap-repl",
  callback = function()
    vim.keymap.set("i", "<C-BS>", "<C-S-w>", {buffer = true})
  end
})

-- Assemble hint from desc entries
local function build_hint(heads)
   local lines = {}
   for _, head in ipairs(heads) do
      local key = head[1]
      local desc = head[3] and head[3].desc or ""
      table.insert(lines, string.format(" _%s_: %s", key, desc))
   end
   return table.concat(lines, "\n")
end

function HoverWithAutoCloseAndEsc()
  local view = require("dap.ui.widgets").hover()
  local buf = view.buf

  if not buf then
    return
  end

  -- Close on WinLeave
  vim.api.nvim_create_autocmd("WinLeave", {
    buffer = buf,
    once = true,
    callback = function()
      view.close()
    end,
  })

  -- Close on <Esc>
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '', {
    callback = function()
      view.close()
    end,
    noremap = true,
    silent = true,
  })
end

local heads = {
  { "u", function() dap_view.toggle(true) end, { desc = "toggle [u]i" } },
  { "R", function() dap_view.jump_to_view("repl") end, { desc = "jump to [R]EPL" } },
  { "b", function() dap.toggle_breakpoint() end, { desc = "toggle [b]reakpoint" } },
  { "gb", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = "set conditional [b]reakpoint" } },
  { "l", function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { desc = "toggle [l]og point" } },
  { "r", function() if vim.bo.filetype ~= "dap-float" then dap.continue() end end, { desc = "[r]un" } },
  { "s", function() if vim.bo.filetype ~= "dap-float" then print(vim.bo.filetype) dap.step_over() end end, { desc = "[s]tep over" } },
  { "go", function() if vim.bo.filetype ~= "dap-float" then dap.step_out() end end, { desc = "step [o]ut" } },
  { "t", function() if vim.bo.filetype ~= "dap-float" then dap.step_into({askForTargets=true}) end end, { desc = "step in[t]o" } },
  { "q", function() dap.terminate() end, { desc = "[q]uit" }},
  { "h", function() HoverWithAutoCloseAndEsc() end, { desc = "[h]over" } },
  { "f", function() dap.focus_frame() end, { desc = "[f]ocus frame" } },
  { "gr", function() dap.restart() end, { desc = "[r]estart session" } },
  { "gt", function() dap.run_to_cursor() end, { desc = "[g]o [t]o cursor" } },
  { "g?", function() if DapHydra.hint.win then DapHydra.hint:close() else DapHydra.hint:show() end end, { desc = "show/hide hint" } },
  { "gv", function() dap_virtual_text.toggle() end, { desc = "toggle [v]irtual text" } },
  { "<S-Down>", function () dap.up() end, { desc = "move down in stacktrace" } },
  { "<S-Up>", function () dap.down() end, { desc = "move up in stacktrace" } },
  { '<Esc>', nil, { exit = true, nowait = true } },
}

local hint = build_hint(heads)

DapHydra = Hydra({
   name = "DEBUG",
   hint = hint,
   config = {
      desc = "Debug mode",
      color = "pink",
      invoke_on_body = true,
      hint = {
          type = "window",
          position = "bottom-right",
          hide_on_load = true,
      },
      on_enter = function ()
        lualine.refresh()
      end,
      on_exit = function ()
        lualine.refresh()
      end,
   },
   mode = 'n',
   body = '<leader>d',
   heads = heads,
})
