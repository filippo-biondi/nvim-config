local neorg = require("neorg")

neorg.setup {
  load = {
    ["core.defaults"] = {},
    ["core.concealer"] = {},
    ["core.neorgcmd"] = {},
    ["core.neorgcmd.commands.return"] = {},
    ["core.dirman"] = {
      config = {
        workspaces = {
          notes = "~/notes",
        },
        default_workspace = "notes",
      },
    },
  },
}

local telescope = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function select_workspace()
    local workspaces = neorg.modules.get_module("core.dirman").get_workspaces()
    local workspace_names = vim.tbl_keys(workspaces)

    telescope.new({}, {
        prompt_title = "Select Neorg Workspace",
        finder = finders.new_table(workspace_names),
        sorter = require("telescope.config").values.generic_sorter({}),
        layout_strategy = "vertical",
        layout_config = {
            width = 0.3,
            height = 0.5,
        },
        attach_mappings = function(_, map)
            actions.select_default:replace(function(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if selection then
                    vim.cmd("Neorg workspace " .. selection[1])
                end
            end)
            return true
        end,
    }):find()
end

local function neorg_return()
  local buffers = vim.api.nvim_list_bufs()

  local to_delete = {}
  for buffer in vim.iter(buffers):rev() do
    if vim.fn.buflisted(buffer) == 1 then
    -- If the listed buffer we're working with has a .norg extension then remove it (not forcibly)
      if not vim.endswith(vim.api.nvim_buf_get_name(buffer), ".norg") then
        vim.api.nvim_win_set_buf(0, buffer)
        break
      else
        table.insert(to_delete, buffer)
      end
    end
  end

  for _, buffer in ipairs(to_delete) do
    vim.api.nvim_buf_delete(buffer, {})
  end
end

vim.keymap.set("n", "<leader>nw", select_workspace, { desc = "Select Neorg Workspace" })
vim.keymap.set("n", "<leader>nc", neorg_return, { desc = "Close open notes" })
