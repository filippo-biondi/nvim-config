if vim.g.did_load_dap_view_plugin then
  return
end
vim.g.did_load_dap_view_plugin = true

local dap = require("dap")
local dap_view = require("dap-view")

dap_view.setup({
  winbar = {
    sections = { "repl", "watches", "scopes", "breakpoints", "exceptions", "threads" },
    default_section = "repl",
    headers = {
      breakpoints = "[B]reakpoints",
      scopes = "[S]copes",
      exceptions = "[E]xceptions",
      watches = "[W]atches",
      threads = "[T]hreads",
      repl = "[R]EPL",
      console = "[C]onsole",
    },
    controls = {
      enabled = true,
    },
  },
})

dap.listeners.before.attach["dap-view-config"] = function()
    dap_view.open()
end
dap.listeners.before.launch["dap-view-config"] = function()
    dap_view.open()
end
