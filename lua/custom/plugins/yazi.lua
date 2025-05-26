-- lua/custom/plugins/yazi.lua
return {
  ---@type LazySpec
  'mikavilpas/yazi.nvim',
  event = 'VeryLazy',
  dependencies = {
    -- check the installation instructions at
    -- https://github.com/folke/snacks.nvim
    'folke/snacks.nvim',
  },
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      '<leader>-',
      mode = { 'n', 'v' },
      '<cmd>Yazi<cr>',
      desc = 'Open yazi at the current file',
    },
    {
      -- open in the current working directory
      '<leader>cw',
      '<cmd>Yazi cwd<cr>',
      desc = "Open the file manager in nvim's working directory",
    },
    {
      '<c-up>',
      '<cmd>Yazi toggle<cr>',
      desc = 'Resume the last yazi session',
    },
  },
  ---@type YaziConfig | {}
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = true, -- 在目录中打开 Yazi

    -- open visible splits and quickfix items as yazi tabs for easy navigation
    open_multiple_tabs = true,

    floating_window_scaling_factor = 0.9,
    yazi_floating_window_winblend = 0,

    -- customize the keymaps that are active when yazi is open and focused. The
    -- defaults are listed below. Note that the keymaps simply hijack input and
    -- they are never sent to yazi, so only try to map keys that are never
    -- needed by yazi.
    --
    -- Also:
    -- - use e.g. `open_file_in_tab = false` to disable a keymap
    -- - you can customize only some of the keymaps (not all of them)
    -- - you can opt out of all keymaps by setting `keymaps = false`
    keymaps = {
      show_help = '<f1>',
      open_file_in_vertical_split = '<c-v>',
      open_file_in_horizontal_split = '<c-x>',
      open_file_in_tab = '<c-t>',
      grep_in_directory = '<c-s>',
      replace_in_directory = '<c-g>',
      cycle_open_buffers = '<tab>',
      copy_relative_path_to_selected_files = '<c-y>',
      send_to_quickfix_list = '<c-q>',
      change_working_directory = '<c-\\>',
      open_and_pick_window = '<c-o>',
    },
  },
  -- 👇 if you use `open_for_directories=true`, this is recommended
  init = function()
    -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
    -- vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    vim.api.nvim_create_autocmd('VimEnter', {
      group = vim.api.nvim_create_augroup('YaziStartDirectory', { clear = true }),
      desc = 'Start Yazi with directory',
      once = true,
      callback = function()
        local arg = vim.fn.argv(0)
        local stats = arg and vim.uv.fs_stat(arg)
        if stats and stats.type == 'directory' then
          -- 加载 yazi
          require 'yazi'
          -- 启动 yazi 替代缓冲区
          vim.cmd 'bd' -- 删除初始空缓冲区
        end
      end,
    })
  end,
}
