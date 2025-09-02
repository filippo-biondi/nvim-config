if vim.g.did_load_keymaps_plugin then
  return
end
vim.g.did_load_keymaps_plugin = true

local api = vim.api
local fn = vim.fn
local keymap = vim.keymap
local diagnostic = vim.diagnostic

-- Yank from current position till end of current line
keymap.set('n', 'Y', 'y$', { silent = true, desc = '[Y]ank to end of line' })

-- Buffer list navigation
keymap.set('n', '[b', vim.cmd.bprevious, { silent = true, desc = 'previous [b]uffer' })
keymap.set('n', ']b', vim.cmd.bnext, { silent = true, desc = 'next [b]uffer' })
keymap.set('n', '[B', vim.cmd.bfirst, { silent = true, desc = 'first [B]uffer' })
keymap.set('n', ']B', vim.cmd.blast, { silent = true, desc = 'last [B]uffer' })

-- Toggle the quickfix list (only opens if it is populated)
local function toggle_qf_list()
  local qf_exists = false
  for _, win in pairs(fn.getwininfo() or {}) do
    if win['quickfix'] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd.cclose()
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd.copen()
  end
end

keymap.set('n', '<C-c>', toggle_qf_list, { desc = 'toggle quickfix list' })

local function try_fallback_notify(opts)
  local success, _ = pcall(opts.try)
  if success then
    return
  end
  success, _ = pcall(opts.fallback)
  if success then
    return
  end
  vim.notify(opts.notify, vim.log.levels.INFO)
end

-- Cycle the quickfix and location lists
local function cleft()
  try_fallback_notify {
    try = vim.cmd.cprev,
    fallback = vim.cmd.clast,
    notify = 'Quickfix list is empty!',
  }
end

local function cright()
  try_fallback_notify {
    try = vim.cmd.cnext,
    fallback = vim.cmd.cfirst,
    notify = 'Quickfix list is empty!',
  }
end

keymap.set('n', '[c', cleft, { silent = true, desc = '[c]ycle quickfix left' })
keymap.set('n', ']c', cright, { silent = true, desc = '[c]ycle quickfix right' })
keymap.set('n', '[C', vim.cmd.cfirst, { silent = true, desc = 'first quickfix entry' })
keymap.set('n', ']C', vim.cmd.clast, { silent = true, desc = 'last quickfix entry' })

local function lleft()
  try_fallback_notify {
    try = vim.cmd.lprev,
    fallback = vim.cmd.llast,
    notify = 'Location list is empty!',
  }
end

local function lright()
  try_fallback_notify {
    try = vim.cmd.lnext,
    fallback = vim.cmd.lfirst,
    notify = 'Location list is empty!',
  }
end

keymap.set('n', '[l', lleft, { silent = true, desc = 'cycle [l]oclist left' })
keymap.set('n', ']l', lright, { silent = true, desc = 'cycle [l]oclist right' })
keymap.set('n', '[L', vim.cmd.lfirst, { silent = true, desc = 'first [L]oclist entry' })
keymap.set('n', ']L', vim.cmd.llast, { silent = true, desc = 'last [L]oclist entry' })

-- Resize vertical splits
local toIntegral = math.ceil
keymap.set('n', '<leader>w+', function()
  local curWinWidth = api.nvim_win_get_width(0)
  api.nvim_win_set_width(0, toIntegral(curWinWidth * 3 / 2))
end, { silent = true, desc = 'inc window [w]idth' })
keymap.set('n', '<leader>w-', function()
  local curWinWidth = api.nvim_win_get_width(0)
  api.nvim_win_set_width(0, toIntegral(curWinWidth * 2 / 3))
end, { silent = true, desc = 'dec window [w]idth' })
keymap.set('n', '<leader>h+', function()
  local curWinHeight = api.nvim_win_get_height(0)
  api.nvim_win_set_height(0, toIntegral(curWinHeight * 3 / 2))
end, { silent = true, desc = 'inc window [h]eight' })
keymap.set('n', '<leader>h-', function()
  local curWinHeight = api.nvim_win_get_height(0)
  api.nvim_win_set_height(0, toIntegral(curWinHeight * 2 / 3))
end, { silent = true, desc = 'dec window [h]eight' })

-- Close floating windows [Neovim 0.10 and above]
keymap.set('n', '<leader>fq', function()
  vim.cmd('fclose!')
end, { silent = true, desc = '[f]loating windows: [q]uit/close all' })

-- Remap Esc to switch to normal mode and Ctrl-Esc to pass Esc to terminal
keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'switch to normal mode' })
keymap.set('t', '<C-Esc>', '<Esc>', { desc = 'send Esc to terminal' })

keymap.set('n', '<space>tn', vim.cmd.tabnew, { desc = '[t]ab: [n]ew' })
keymap.set('n', '<space>tq', vim.cmd.tabclose, { desc = '[t]ab: [q]uit/close' })

local severity = diagnostic.severity

keymap.set('n', '<space>e', function()
  local _, winid = diagnostic.open_float(nil, { scope = 'line' })
  if not winid then
    vim.notify('no diagnostics found', vim.log.levels.INFO)
    return
  end
  vim.api.nvim_win_set_config(winid or 0, { focusable = true })
end, { noremap = true, silent = true, desc = 'diagnostics floating window' })
keymap.set('n', '[d', diagnostic.goto_prev, { noremap = true, silent = true, desc = 'previous [d]iagnostic' })
keymap.set('n', ']d', diagnostic.goto_next, { noremap = true, silent = true, desc = 'next [d]iagnostic' })
keymap.set('n', '[e', function()
  diagnostic.goto_prev {
    severity = severity.ERROR,
  }
end, { noremap = true, silent = true, desc = 'previous [e]rror diagnostic' })
keymap.set('n', ']e', function()
  diagnostic.goto_next {
    severity = severity.ERROR,
  }
end, { noremap = true, silent = true, desc = 'next [e]rror diagnostic' })
keymap.set('n', '[w', function()
  diagnostic.goto_prev {
    severity = severity.WARN,
  }
end, { noremap = true, silent = true, desc = 'previous [w]arning diagnostic' })
keymap.set('n', ']w', function()
  diagnostic.goto_next {
    severity = severity.WARN,
  }
end, { noremap = true, silent = true, desc = 'next [w]arning diagnostic' })
keymap.set('n', '[h', function()
  diagnostic.goto_prev {
    severity = severity.HINT,
  }
end, { noremap = true, silent = true, desc = 'previous [h]int diagnostic' })
keymap.set('n', ']h', function()
  diagnostic.goto_next {
    severity = severity.HINT,
  }
end, { noremap = true, silent = true, desc = 'next [h]int diagnostic' })

local function toggle_spell_check()
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.opt.spell = not (vim.opt.spell:get())
end

keymap.set('n', '<leader>S', toggle_spell_check, { noremap = true, silent = true, desc = 'toggle [S]pell' })

local function jump_to_next_paragraph()
  local bufnr = vim.api.nvim_get_current_buf()
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  local total_lines = vim.api.nvim_buf_line_count(bufnr)

  local found_blank = false

  for lnum = cur_line + 1, total_lines do
    local line = vim.fn.getline(lnum)

    if not found_blank then
      if line:match("^%s*$") then
        found_blank = true
      end
    else
      if not line:match("^%s*$") then
        vim.api.nvim_win_set_cursor(0, {lnum, 0})
        return
      end
    end
  end

  -- If we didn't find another paragraph, jump to the last non-blank line
  for lnum = total_lines, cur_line + 1, -1 do
    local line = vim.fn.getline(lnum)
    if not line:match("^%s*$") then
      vim.api.nvim_win_set_cursor(0, {lnum, 0})
      return
    end
  end
end

local function jump_to_previous_paragraph()
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]

  -- Find the first line of the current paragraph
  local function find_paragraph_start(line)
    while line > 1 do
      local prev = vim.fn.getline(line - 1)
      if prev:match("^%s*$") then
        break
      end
      line = line - 1
    end
    return line
  end

  local current_start = find_paragraph_start(cur_line)

  -- If we're not at the start already, go to the start of current paragraph
  if cur_line ~= current_start then
    vim.api.nvim_win_set_cursor(0, {current_start, 0})
    return
  end

  -- Otherwise, scan upward to find the previous paragraph
  local lnum = current_start - 1
  while lnum > 0 do
    local line = vim.fn.getline(lnum)
    if not line:match("^%s*$") then
      local prev_start = find_paragraph_start(lnum)
      vim.api.nvim_win_set_cursor(0, {prev_start, 0})
      return
    end
    lnum = lnum - 1
  end

  -- If no previous paragraph, go to the first non-blank line
  for i = 1, current_start - 1 do
    if not vim.fn.getline(i):match("^%s*$") then
      vim.api.nvim_win_set_cursor(0, {i, 0})
      return
    end
  end
end

keymap.set({'n', 'v', 'i'}, '<C-Up>', jump_to_previous_paragraph, { desc = 'move up one paragraph' })
keymap.set({'n', 'v', 'i'}, '<C-Down>', jump_to_next_paragraph, { desc = 'move down one paragraph' })
keymap.set('n', '<S-Down>', '<Down>', { silent = true })
keymap.set('n', '<S-Up>', '<Up>', { silent = true })

keymap.set({'i', 't'}, '<C-BS>', '<C-w>', { desc = 'delete untill stard of word' })
keymap.set({'i', 't'}, '<S-DEL>', '<DEL>', { desc = 'delete untill end of word' })
keymap.set({'i', 't'}, '<C-DEL>', '<C-o>dw', { desc = 'delete untill end of word' })
keymap.set({'i', 't'}, '<C-S-DEL>', '<DEL><C-o>dw', { desc = 'delete untill end of word' })

keymap.set('n', '<ESC><ESC>', ':noh | nohlsearch<CR>', { desc = 'remove search highlight', silent = true })

keymap.set('n', '<C-S-c>', require('osc52').copy_operator, {expr = true})
keymap.set('n', '<C-S-c><C-S-c>', '<C-S-c>_', {remap = true})
keymap.set('v', '<C-S-c>', require('osc52').copy_visual)

keymap.set({'n', 'v'}, '<C-Left>', 'b', { desc = 'move one wold left' })
keymap.set({'n', 'v'}, '<C-Right>', 'w', { desc = 'move one wold left' })

keymap.set({'i', 't'}, '<C-w>', '<ESC><C-w>', { noremap = true, silent = true })

keymap.set('n', "A", [[ getline('.') == '' ? 'cc' : 'A' ]], { expr = true, noremap = true, silent = true })

-- map <C-T> to open a new terminal
keymap.set('n', '<C-t>', ':term<CR>i', { noremap = true, desc = 'open a new terminal' })

keymap.set({'n', 'v'}, '<D-Left>', '<C-w>h', { noremap = true, silent = true })
keymap.set({'i', 't'}, '<D-Left>', '<esc><C-w>h', { noremap = true, silent = true })
keymap.set({'n', 'v'}, '<D-Right>', '<C-w>l', { noremap = true, silent = true })
keymap.set({'i', 't'}, '<D-Right>', '<esc><C-w>l', { noremap = true, silent = true })
keymap.set({'n', 'v'}, '<D-Up>', '<C-w>k', { noremap = true, silent = true })
keymap.set({'i', 't'}, '<D-Up>', '<esc><C-w>k', { noremap = true, silent = true })
keymap.set({'n', 'v'}, '<D-Down>', '<C-w>j', { noremap = true, silent = true })
keymap.set({'i', 't'}, '<D-Down>', '<esc><C-w>j', { noremap = true, silent = true })

vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')

-- smart Home key
vim.keymap.set({ 'n', 'v'}, '<Home>', function()
  local col = vim.fn.col('.')
  local first_nonblank = vim.fn.matchstrpos(vim.fn.getline('.'), [[\S]])[2] + 1
  if col == first_nonblank then
    return '0'
  else
    return '^'
  end
end, { expr = true, noremap = true })
