-- ~/.config/nvim/lua/custom/options.lua
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 20

-- 指定系统 python 路径
vim.g.python3_host_prog = '/usr/bin/python3'

vim.g.perl_host_prog = '/usr/bin/perl'

-- vim.opt.tabstop = 4
-- vim.opt.shiftwidth = 4
-- vim.opt.expandtab = true

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
vim.g.lazygit_floating_window_border_chars = {'╭','─', '╮', '│', '╯','─', '╰', '│'} -- customize lazygit popup window border characters
vim.g.lazygit_floating_window_use_plenary = 0 -- use plenary.nvim to manage floating window if available
vim.g.lazygit_use_neovim_remote = 1 -- fallback to 0 if neovim-remote is not installed

vim.g.lazygit_use_custom_config_file_path = 0 -- config file path is evaluated if this value is 1
vim.g.lazygit_config_file_path = '' -- custom config file path
-- OR
vim.g.lazygit_config_file_path = {} -- table of custom config file paths

vim.g.lazygit_on_exit_callback = nil -- optional function callback when exiting lazygit (useful for example to refresh some UI elements after lazy git has made some changes)

