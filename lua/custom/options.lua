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

