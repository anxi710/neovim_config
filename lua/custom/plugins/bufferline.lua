-- lua/custom/plugin/bufferline.lua
return {
  'akinsho/bufferline.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  config = function()
    require('bufferline').setup {
      options = {
        mode = 'buffers',
        numbers = 'ordinal',
        diagnostics = 'nvim_lsp',
        show_buffer_close_icons = true,
        show_close_icon = false,
        separator_style = 'slant',
        always_show_bufferline = true,

        offsets = {
          {
            filetype = 'neo-tree',
            text = 'File Explorer',
            hightlight = 'Directory',
            text_align = 'center',
            separator = true,
          },
        },
      },
    }
  end,
}
