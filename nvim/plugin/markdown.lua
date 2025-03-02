require('render-markdown').setup({
  render_modes = { 'n', 'c', 't' },
  latex = {
    enabled = false,
  },
  win_options = { conceallevel = { rendered = 2 } },
  on = {
    render = function()
      require('nabla').enable_virt({ autogen = true })
    end,
    clear = function()
      require('nabla').disable_virt()
    end,
  },
})
