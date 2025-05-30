-- lua/custom/plugins/yazi.lua
return {
  -- Yazi 是一个功能强大的 TUI 文件资源管理器，替代 neo-tree 作为主文件管理器
  ---@type LazySpec
  'mikavilpas/yazi.nvim',
  event = 'VeryLazy', -- 注意：这意味着 Yazi 必须主动加载
  dependencies = {
    -- check the installation instructions at
    -- https://github.com/folke/snacks.nvim
    'folke/snacks.nvim',
    -- 'MagicDuck/grug-far.nvim',
  },
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      '<leader>e',
      mode = { 'n' },
      '<cmd>Yazi<cr>',
      desc = '[E]xplorer (Open yazi at the current file)',
    },
    {
      -- open in the current working directory
      '<leader>cw',
      '<cmd>Yazi cwd<cr>',
      desc = 'Open yazi in the [c]urrent [w]orking directory',
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
      grep_in_directory = '<c-g>', -- 在当前目录下使用 grep 查找所有文件中的内容
      replace_in_directory = false, -- 当下暂不使用该功能（依赖于 grug-far.nvim）
      cycle_open_buffers = '<tab>', -- 快速跳转到当前打开的 buffer 对应文件
      copy_relative_path_to_selected_files = '<c-y>',
      send_to_quickfix_list = '<c-q>',
      change_working_directory = '<c-\\>',

      open_file_in_vertical_split = '<C-v>',
      open_file_in_horizontal_split = '<C-h>',
      open_file_in_tab = 'T',
      open_and_pick_window = '<c-o>',
    },
    -- 使用自定义的文件打开命令，yazi 内置命令在我的设备上有问题
    open_fn = function(path, method)
      if method == 'vsplit' then
        vim.cmd('vsplit ' .. vim.fn.fnameescape(path))
      elseif method == 'hsplit' then
        vim.cmd('split ' .. vim.fn.fnameescape(path))
      elseif method == 'tab' then
        vim.cmd('tabnew ' .. vim.fn.fnameescape(path))
      else
        vim.cmd('edit ' .. vim.fn.fnameescape(path))
      end
    end,

    -- 悬浮窗边框
    yazi_floating_window_border = 'rounded',

    -- 一些 yazi 的命令拷贝文本到剪切板，这是 yazi 应该用于拷贝的缓冲区
    -- 默认是 * - 系统剪切板
    clipboard_register = '*',

    hooks = {
      -- if you want to execute a custom action when yazi has been opened,
      -- you can define it here.
      yazi_opened = function(preselected_path, yazi_buffer_id, config)
        -- you can optionally modify the config for this specific yazi
        -- invocation if you want to customize the behaviour
      end,

      -- when yazi was successfully closed
      yazi_closed_successfully = function(chosen_file, config, state) end,

      -- when yazi opened multiple files. The default is to send them to the
      -- quickfix list, but if you want to change that, you can define it here
      yazi_opened_multiple_files = function(chosen_files, config, state) end,
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
