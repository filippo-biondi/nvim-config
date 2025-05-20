if vim.g.did_load_dial_plugin then
  return
end
vim.g.did_load_dial_plugin = true

vim.keymap.set({'n', 'v'}, '<C-a>', function()
    require("dial.map").manipulate("increment", "normal")
end)

local augend = require("dial.augend")

require("dial.config").augends:register_group{
  default = {
    augend.integer.alias.decimal,
    augend.integer.alias.hex,
    augend.date.alias["%d/%m/%Y"],
    augend.date.alias["%d/%m/%y"],
    augend.constant.alias.bool,
    augend.constant.new{ elements = {"True", "False"} },
    augend.constant.new{ elements = {"yes", "no"} },
    augend.constant.new{ elements = {"on", "off"} },
    augend.constant.new{ elements = {"online", "offline"} },
  }
}
