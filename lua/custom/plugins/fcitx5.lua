-- lua/custom/plugins/fcitx5.lua
return {
  -- 输入法自动切换（使用自定义的 fcitx5 控制器，只在第一次进入 insert mode 下会卡顿）
  'pysan3/fcitx5.nvim',
  cond = vim.fn.executable 'fcitx5-remote' == 1,
  event = { 'InsertEnter', 'InsertLeave' },
  config = function()
    require('fcitx5').setup {
      msg = nil, -- string | nil: printed when startup is completed
      imname = { -- fcitx5.Imname | nil: imnames on each mode set as prior. See `:h map-table` for more in-depth information.
        norm = 'keyboard-us', -- string | nil: imname to set in normal mode. if nil, will restore the mode on exit.
        ins = nil,
        cmd = 'keyboard-us',
        vis = 'keyboard-us',
        sel = 'keyboard-us',
        opr = 'keyboard-us',
        term = 'keyboard-us',
        lang = 'keyboard-us',
      },
      remember_prior = false, -- boolean: if true, it remembers the mode on exit and restore it when entering the mode again.
      --          if false, uses what was set in config.
      define_autocmd = false, -- boolean: if true, defines autocmd at `ModeChanged` to switch fcitx5 mode.
      autostart_fcitx5 = false, -- boolean: if true, autostarts `fcitx5` when it is not running.
      log = 'warn', -- string: log level (default: warn)
    }
    -- 引入自定义控制器模块
    require('custom.fcitx5-controller').setup()
  end,
}
