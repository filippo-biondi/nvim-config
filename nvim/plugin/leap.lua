if vim.g.did_load_leap_plugin then
  return
end
vim.g.did_load_leap_plugin = true

require('leap').set_default_mappings()
