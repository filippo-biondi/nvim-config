local cmd = vim.cmd
local fn = vim.fn
local o = vim.o
local opt = vim.opt
local g = vim.g

g.mapleader = ' '
g.maplocalleader = ' '

if vim.fn.argc() == 0 then
    cmd('cd ' .. fn.expand('%:p:h'))
    cmd('edit .')
end

o.compatible = false
o.wrap = false

-- Enable true colour support
if fn.has('termguicolors') then
  o.termguicolors = true
end

-- See :h <option> to see what the options do

-- Search down into subfolders
o.path = o.path .. '**'

o.number = true
o.relativenumber = true
o.cursorline = true
o.timeout = false
o.timeoutlen = 0
o.ignorecase = true
o.smartcase = true
o.incsearch = true
o.hlsearch = true

o.spelllang = 'en'

o.spell = true
o.expandtab = true
o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2
o.foldenable = true
o.history = 2000
o.nrformats = 'bin,hex' -- 'octal'
o.undofile = true
o.splitright = true
o.splitbelow = true

opt.guicursor = {
  "n-v:block",
  "i-c-ci-ve:ver25",
  "r-cr:hor20",
  "o:hor50",
  "sm:block"
}

o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

-- Configure Neovim diagnostic messages

local function prefix_diagnostic(prefix, diagnostic)
  return string.format(prefix .. ' %s', diagnostic.message)
end

vim.diagnostic.config {
  virtual_text = {
    prefix = '',
    format = function(diagnostic)
      local severity = diagnostic.severity
      if severity == vim.diagnostic.severity.ERROR then
        return prefix_diagnostic('󰅚', diagnostic)
      end
      if severity == vim.diagnostic.severity.WARN then
        return prefix_diagnostic('⚠', diagnostic)
      end
      if severity == vim.diagnostic.severity.INFO then
        return prefix_diagnostic('ⓘ', diagnostic)
      end
      if severity == vim.diagnostic.severity.HINT then
        return prefix_diagnostic('󰌶', diagnostic)
      end
      return prefix_diagnostic('■', diagnostic)
    end,
  },
  signs = {
    text = {
      -- Requires Nerd fonts
      [vim.diagnostic.severity.ERROR] = '󰅚',
      [vim.diagnostic.severity.WARN] = '⚠',
      [vim.diagnostic.severity.INFO] = 'ⓘ',
      [vim.diagnostic.severity.HINT] = '󰌶',
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'if_many',
    header = '',
    prefix = '',
  },
}

g.editorconfig = true

o.colorcolumn = '100'

cmd.colorscheme "catppuccin-mocha"

vim.cmd("highlight! link CursorLineNr Normal")
vim.cmd("highlight! link LineNrAbove Normal")
vim.cmd("highlight! link LineNrBelow Normal")

opt.iskeyword:remove("_")

-- Native plugins
cmd.filetype('plugin', 'indent', 'on')
cmd.packadd('cfilter') -- Allows filtering the quickfix list with :cfdo

-- let sqlite.lua (which some plugins depend on) know where to find sqlite
vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')
