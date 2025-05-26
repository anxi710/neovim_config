-- lua/custom/keymaps.lua
local M = {}

local map = vim.keymap.set

local function window_keymaps()
  -- 窗口移动
  map('n', '<leader>wh', '<C-w>h', { desc = 'Window: Move left', noremap = true, silent = true })
  map('n', '<leader>wj', '<C-w>j', { desc = 'Window: Move down', noremap = true, silent = true })
  map('n', '<leader>wk', '<C-w>k', { desc = 'Window: Move up', noremap = true, silent = true })
  map('n', '<leader>wl', '<C-w>l', { desc = 'Window: Move right', noremap = true, silent = true })

  -- 窗口分割与调整
  map('n', '<leader>ws', '<C-w>s', { desc = 'Window: Split horizontal', noremap = true, silent = true })
  map('n', '<leader>wv', '<C-w>v', { desc = 'Window: Split vertical', noremap = true, silent = true })
  map('n', '<leader>w=', '<C-w>=', { desc = 'Window: Equalize', noremap = true, silent = true })

  -- 窗口循环与关闭
  map('n', '<leader>ww', '<C-w>w', { desc = 'Window: Cycle', noremap = true, silent = true })
  map('n', '<leader>wq', '<C-w>q', { desc = 'Window: Close', noremap = true, silent = true })
  map('n', '<leader>wx', '<C-w>x', { desc = 'Window: Swap', noremap = true, silent = true })
end

local function tab_keymaps()
  for i = 1, 9 do
    map('n', '<leader>t' .. i, i .. 'gt', { desc = 'Tab: Go to ' .. i, noremap = true, silent = true })
  end

  map('n', '<leader>tn', ':tabnew<CR>', { desc = 'Tab: New', noremap = true, silent = true })

  map('n', '<leader>tc', function()
    if #vim.api.nvim_list_tabpages() <= 1 then
      vim.cmd 'Neotree close'
      vim.cmd 'qa'
    else
      vim.cmd 'tabclose'
    end
  end, { desc = 'Tab: Close or quit', noremap = true, silent = true })

  map('n', '<leader>to', ':tabonly<CR>', { desc = 'Tab: Only current', noremap = true, silent = true })

  vim.api.nvim_create_autocmd('TabClosed', {
    callback = function()
      if #vim.api.nvim_list_tabpages() == 1 and #vim.fn.getbufinfo { buflisted = 1 } == 0 then
        vim.cmd 'qa'
      end
    end,
  })
end

function M.setup()
  window_keymaps()
  tab_keymaps()
end

return M
