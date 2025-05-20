if vim.g.did_load_lualine_plugin then
  return
end
vim.g.did_load_lualine_plugin = true

local navic = require('nvim-navic')
navic.setup {}
local hydra_statusline = require('hydra.statusline')

---Indicators for special modes,
---@return string status
local function extra_mode_status()
  -- recording macros
  local reg_recording = vim.fn.reg_recording()
  if reg_recording ~= '' then
    return ' @' .. reg_recording
  end
  -- executing macros
  local reg_executing = vim.fn.reg_executing()
  if reg_executing ~= '' then
    return ' @' .. reg_executing
  end
  -- ix mode (<C-x> in insert mode to trigger different builtin completion sources)
  local mode = vim.api.nvim_get_mode().mode
  if mode == 'ix' then
    return '^X: (^]^D^E^F^I^K^L^N^O^Ps^U^V^Y)'
  end
  return ''
end


local function refresh_name(str)
  if hydra_statusline.is_active() == true and vim.fn.mode() == "n" then
    return hydra_statusline.get_name()
  end
  return str
end

local function refresh_color(tb)
  if hydra_statusline.is_active() == true and vim.fn.mode() == "n" then
    return {bg = hydra_statusline.get_color()}
  end
  return tb
end

require('lualine').setup {
  globalstatus = true,
  sections = {
    lualine_a = {
        {
          'mode',
          fmt = refresh_name,
          color = refresh_color,
        }
      },
    lualine_c = {
      -- nvim-navic
      { navic.get_location, cond = navic.is_available },
    },
    lualine_z = {
      -- (see above)
      { extra_mode_status },
    },
  },
  options = {
    disabled_filetypes = {
      winbar = { 'dap-view', 'dap-repl', 'dap-view-term', 'NvimTree', 'neo-tree', 'Outline', 'TelescopePrompt', 'toggleterm', 'help', 'alpha', 'dashboard' },
    },
    theme = 'auto',
  },
  winbar = {
    lualine_a = {
      {
        'buffers',
        show_filename_only = true,
        hide_filename_extension = false,
        show_modified_status = true,

        mode = 0,
        max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
                                            -- it can also be a function that returns
                                            -- the value of `max_length` dynamically.
        filetype_names = {
          TelescopePrompt = 'Telescope',
          dashboard = 'Dashboard',
          packer = 'Packer',
          fzf = 'FZF',
          alpha = 'Alpha'
        }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )

        symbols = {
          modified = ' ●',      -- Text to show when the buffer is modified
          alternate_file = '#', -- Text to show to identify the alternate file
          directory =  '',     -- Text to show when the buffer is a directory
        }
      }
    },
    lualine_z = {
      {
        'filename',
        path = 1,
        file_status = true,
        newfile_status = true,
        color = refresh_color
      },
    },
  },
  extensions = { 'fugitive', 'fzf', 'toggleterm', 'quickfix', 'nvim-tree' },
}
