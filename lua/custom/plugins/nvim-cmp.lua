-- lua/custom/plugins/nvim-cmp.lua
return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
  },
  config = function()
    local cmp = require 'cmp'
    cmp.setup {
      mapping = cmp.mapping.preset.insert {
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<CR>'] = cmp.mapping.confirm { select = true },
      },
      sources = {
        { name = 'buffer' },
        { name = 'path' },
      },
    }

    cmp.setup.cmdline(':', {
      sources = {
        { name = 'cmdline' },
      },
    })
  end,
}
