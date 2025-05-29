-- ~/.config/nvim/lua/custom/options.lua
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 20

-- 指定系统 python 路径
vim.g.python3_host_prog = '/usr/bin/python3'

vim.g.perl_host_prog = '/usr/bin/perl'

-- 自动切换相对行号
vim.opt.relativenumber = true -- 设置初始状态为相对行号
vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
  callback = function()
    vim.opt.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
  callback = function()
    vim.opt.relativenumber = true
  end,
})

vim.g.EditorConfig_exclude_patterns = { 'health://*', 'term://*' }

-- LazyGit
vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window
vim.g.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
vim.g.lazygit_floating_window_border_chars = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' } -- customize lazygit popup window border characters
vim.g.lazygit_floating_window_use_plenary = 0 -- use plenary.nvim to manage floating window if available
vim.g.lazygit_use_neovim_remote = 1 -- fallback to 0 if neovim-remote is not installed

vim.g.lazygit_use_custom_config_file_path = 0 -- config file path is evaluated if this value is 1
vim.g.lazygit_config_file_path = '' -- custom config file path
-- OR
vim.g.lazygit_config_file_path = {} -- table of custom config file paths

vim.g.lazygit_on_exit_callback = nil -- optional function callback when exiting lazygit (useful for example to refresh some UI elements after lazy git has made some changes)

-- Folding
-- foldminlines & foldnestmax
vim.wo.foldenable = true
-- 使用 nvim-ufo 来智能化处理 fold，因此不需要下面两行
-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- Tab
vim.o.tabstop = 4 -- tab 显示为 4 个空格宽
vim.o.shiftwidth = 4 -- 每次缩进使用 4 个空格
vim.o.softtabstop = 4 -- Tab 键时退格/缩进行为
vim.o.expandtab = true -- 将 Tab 转为空格

vim.o.fileencoding = 'utf-8'
vim.o.encoding = 'utf-8'

vim.o.autoindent = true -- 启用自动缩进
vim.o.smartindent = true -- 智能缩进（适用于 C 风格语言）
vim.o.smarttab = true -- Tab 键行为更智能
vim.o.breakindent = true -- 换行时保留缩进

-- 开启空白字符显示
vim.o.list = true
vim.opt.listchars = {
  -- space = '·', -- 空格
  tab = '» ', -- 制表符（Tab），后面有空格表示对齐
  trail = '·', -- 行尾多余空格
  extends = '›', -- 超出右侧边界
  precedes = '‹', -- 超出左侧边界
  nbsp = '␣', -- 不换行空格（non-breaking space）
}
