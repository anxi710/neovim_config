-- lua/custom/plugins/lualine.lua
return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  config = function()
    require('lualine').setup {
      options = {
        theme = 'auto',
        section_separators = '',
        component_separators = '',
        icons_enabled = true,
        globalstatus = true,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          'branch',
          'diff',
          { 'diagnostics', sources = { 'nvim_lsp' }, symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' } },
        },
        lualine_c = {
          'filename',
          function()
            return require('custom.fcitx5-controller').get_current_im()
          end,
        },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      extensions = { 'nvim-tree', 'quickfix' },
    }
  end,
}
