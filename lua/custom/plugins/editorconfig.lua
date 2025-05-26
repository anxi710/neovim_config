-- lua/custom/plugins/editorconfig.lua
return {
  -- 相较 editorconfig.vim 更轻量
  'gpanders/editorconfig.nvim',
  event = { 'BufReadPre', 'BufNewFile' }, -- 延迟加载，提升启动性能
}
