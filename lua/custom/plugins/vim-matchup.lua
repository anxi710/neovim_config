return {
  'andymass/vim-matchup',
  init = function()
    -- 启用高级高亮和延迟匹配
    vim.g.matchup_matchparen_enabled = 1
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_hi_surround_always = 1
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
  end
}