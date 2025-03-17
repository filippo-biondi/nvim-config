local function smart_delete(key)
	local l = vim.api.nvim_win_get_cursor(0)[1] -- Get the current cursor line number
	local line = vim.api.nvim_buf_get_lines(0, l - 1, l, true)[1] -- Get the content of the current line
	return (line:match("^%s*$") and '"_' or "") .. key -- If the line is empty or contains only whitespace, use the black hole register
end

local keys = { "d", "dd", "x", "c", "s", "C", "S", "X" } -- Define a list of keys to apply the smart delete functionality

-- Set keymaps for both normal and visual modes
for _, key in pairs(keys) do
	vim.keymap.set({ "n", "v" }, key, function()
		return smart_delete(key)
	end, { noremap = true, expr = true, desc = "Smart delete" })
end
