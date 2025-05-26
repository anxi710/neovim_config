-- lua/custom/plugins/vim-tpipeline.lua
return {
  'vimpostor/vim-tpipeline',
  config = function()
    -- 自动绑定 vim 状态栏到 tmux
    vim.g.tpipeline_autoembed = 1
    vim.g.tpiptline_restore = 1
    vim.g.tpipeline_clearstl = 1
  end,
}
