-- lua/custom/keymaps.lua
local M = {}

local function map(...)
  vim.keymap.set(...)
end

-- 同步确认函数（Yes/No）
local function confirm_sync(prompt)
  local answer = vim.fn.input(prompt .. ' (y/N): ')
  return answer:lower() == 'y'
end

-- 智能关闭 buffer（在必要时退出 Neovim）
local function close_buffer_safely()
  local listed_buffers = vim.fn.getbufinfo { buflisted = 1 }

  if #listed_buffers <= 1 then
    if confirm_sync 'Quit Neovim?' then
      vim.cmd 'qa'
    else
      vim.cmd 'bd'
      vim.cmd 'Yazi'
    end
    return
  end

  vim.cmd 'bd' -- 使用 bd 命令会同时关闭 buffer 对应窗口
end

-- 智能关闭 window（）
local function close_window_safely()
  local bufnr = vim.api.nvim_get_current_buf()
  local windows = vim.fn.win_findbuf(bufnr)
  local win_count = #vim.api.nvim_list_wins()

  -- 如果当前关闭的 window 中显示的 buffer 只有这一个显示窗口
  if #windows <= 1 then
    if confirm_sync 'Close this window?' then
      -- 如果当前只有一个窗口则不能通过 close 来关闭
      -- 而是需要使用 bd 来关闭当前窗口对应的 buffer 从而关闭当前窗口
      if win_count > 1 then
        vim.cmd 'close'
      else
        close_buffer_safely()
      end
    end
    return
  else
    vim.cmd 'close'
  end
end

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
  map('n', '<leader>wq', close_window_safely, { desc = 'Window: Close safely', noremap = true, silent = true })
  map('n', '<leader>wx', '<C-w>x', { desc = 'Window: Swap', noremap = true, silent = true })
end

local function tab_keymaps()
  for i = 1, 9 do
    map('n', '<leader>t' .. i, i .. 'gt', { desc = 'Tab: Go to ' .. i, noremap = true, silent = true })
  end
  map('n', '<leader>tn', function()
    vim.cmd 'tabnew'

    -- 删除 tabnew 自动创建的空 buffer（未命名）
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.api.nvim_buf_get_name(bufnr) == '' and vim.bo[bufnr].buftype == '' then
      -- unnamed 且不是特殊 buftype，如 terminal 等
      vim.cmd 'bd!'
    end

    if not package.loaded['yazi'] then
      local ok, yazi = pcall(require, 'custom.plugins.yazi') -- 注意这里由于 Yazi 设置的是 VeryLazy，因此不会自动加载
      -- 需要手动加载。其次，不能直接调用 pcall(require, 'yazi')
      -- 因为，这样会无法加载我们的自定义配置！！！
      if ok then
        yazi.setup()
      else
        vim.notify('Failed to load plugin yazi', vim.log.levels.ERROR)
        return
      end
    end

    vim.cmd 'Yazi'
  end, { desc = 'Tab: New', noremap = true, silent = true })

  map('n', '<leader>tq', function()
    local tabs = vim.api.nvim_list_tabpages()
    if #tabs > 1 then
      local current_tab = vim.api.nvim_get_current_tabpage()
      local wins = vim.api.nvim_tabpage_list_wins(current_tab)
      local buffers = {}
      for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        buffers[buf] = true
      end
      vim.cmd 'tabprevious'
      vim.cmd 'tabclose #'
      for buf, _ in pairs(buffers) do
        if vim.fn.buflisted(buf) == 1 and vim.fn.bufwinnr(buf) == -1 then
          pcall(vim.cmd, 'bd ' .. buf)
        end
      end
    else
      vim.notify("Only one tab left — can't quit.", vim.log.levels.INFO)
    end
  end, { desc = 'Tab: Quit current + buffers', noremap = true, silent = true })

  map('n', '<leader>to', '<cmd>tabonly<CR>', { desc = 'Tab: Only current', noremap = true, silent = true })

  vim.api.nvim_create_autocmd('TabClosed', {
    callback = function()
      if #vim.api.nvim_list_tabpages() == 1 and #vim.fn.getbufinfo { buflisted = 1 } == 0 then
        vim.cmd 'qa'
      end
    end,
  })
end

local function buffer_keymaps()
  -- 该函数使用 Bufferlien.nvim 提供的函数实现其功能
  -- 因此确保安装了 Bufferline.nvim 插件
  for i = 1, 9 do
    map('n', '<leader>b' .. i, '<cmd>BufferLineGoToBuffer ' .. i .. '<CR>', {
      desc = 'Buffer: Go to ' .. i,
      noremap = true,
      silent = true,
    })
  end

  map('n', '<leader>bn', '<cmd>enew<CR>', { desc = 'Buffer: New empty', noremap = true, silent = true })
  map('n', '<leader>bq', close_buffer_safely, { desc = 'Buffer: Close safely', noremap = true, silent = true })
  map('n', '<leader>bd', close_buffer_safely, { desc = 'Buffer: Close safely', noremap = true, silent = true })
  map('n', '<leader>bo', '<cmd>%bd|e#<CR>', { desc = 'Buffer: Only current', noremap = true, silent = true })
end

function M.setup()
  window_keymaps()
  tab_keymaps()
  buffer_keymaps()
  -- 取消连按两次 <Esc> 键跳回主 buffer
  map('t', '<Esc><Esc>', '<Esc>', { noremap = true })
  -- 在 normal 模式下可以通过 ctrl+a，选中所有内容
  map('n', '<c-a>', function()
    vim.cmd 'normal! ggVG' -- 直接绑定 'gg0vG' 效果不是很稳定，所以使用命令函数的方式执行。这里 normal! 是强制执行正常模式
  end, { noremap = true })
  -- 使用 W 跳转到当前 word 的最后一个字母
  map('n', 'W', 'e', { noremap = true })
  -- 使用 <tab> 来切换折叠状态
  map('n', '<tab>', 'za', { noremap = true })
  -- 显示诊断信息
  map('n', '<leader>dd', vim.diagnostic.open_float, { desc = '显示诊断信息' })
end

return M
