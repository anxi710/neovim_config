return {
  -- Detect tabstop and shiftwidth automatically
  'nmac427/guess-indent.nvim',
  event = 'BufReadPre',
  config = function()
    require('guess-indent').setup {
      auto_cmd = true, -- 默认就是 true
      filetype_exclude = { 'netrw', 'tutor' },
      buftype_exclude = { 'help', 'nofile', 'terminal' },
    }
  end,
}