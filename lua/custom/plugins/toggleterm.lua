-- lua/custom/plugins/toggleterm.lua
return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      open_mapping = [[<c-\>]],
      direction = 'float',
    }

    -- local Terminal = require('toggleterm.terminal').Terminal
    -- local lazygit = Terminal:new {
    --   cmd = 'lazygit',
    --   hidden = true,
    --   direction = 'float',
    -- }
    --
    -- vim.keymap.set('n', '<Leader>lg', function()
    --   lazygit:toggle()
    -- end, { desc = 'Lazygit' })
  end,
}
