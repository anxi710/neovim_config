-- lua/custom/plugins/fzf-lua.lua
return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = 'FzfLua',
  keys = {
    { '<leader>ff', '<cmd>FzfLua files<CR>', desc = 'Find Files' },
    { '<leader>fb', '<cmd>FzfLua buffers<CR>', desc = 'Find Buffers' },
    { '<leader>f/', '<cmd>FzfLua live_grep<CR>', desc = 'Live Grep' },
  },
  config = function()
    require('fzf-lua').setup {
      winopts = {
        preview = { default = 'bat' },
      },
    }
  end,
}
