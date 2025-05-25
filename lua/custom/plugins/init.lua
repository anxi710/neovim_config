-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup()

      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit = Terminal:new {
        cmd = 'lazygit',
        hidden = true,
        direction = 'float',
      }

      vim.keymap.set('n', '<Leader>lg', function()
        lazygit:toggle()
      end, { desc = 'Lazygit' })
    end,
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    config = function()
      require('noice').setup {
        lsp = {
          -- Override markdown rendering so that **cmp** and other plugins use **treesitter**
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true, -- Requires hrsh7th/nvim-cmp
          },
        },
        -- You can enable a preset for easier configuration
        presets = {
          -- bottom_search = true, -- Use a classic bottom cmdline for search
          -- command_palette = true, -- Position the cmdline and popupmenu together
          -- long_message_to_split = true, -- Long messages will be sent to a split
          -- inc_rename = false, -- Enables an input dialog for inc-rename.nvim
          -- lsp_doc_border = true, -- Add a border to hover docs and signature help
        },
      }
    end,
    opts = {
      -- Add any options here
    },
    dependencies = {
      -- If you lazy-load any plugin below, make sure to add proper `module = "..."` entries
      'MunifTanjim/nui.nvim',
      -- Optional:
      -- `nvim-notify` is only needed if you want to use the notification view.
      -- If not available, we use `mini` as the fallback.
      'rcarriga/nvim-notify',
    },
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    opts = {
      enable_git_status = true,
      sources = { 'filesystem', 'buffers', 'git_status' },
      window = {
        mappings = {
          ['<Esc>'] = 'close_window', -- Use <Esc> to close Neo-tree
          ['l'] = 'open',
          ['h'] = 'close_node',
          ['y'] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg('+', path, 'c')
            end,
            desc = 'Copy path to clipboard',
          },
          ['o'] = {
            function(state)
              require('lazy.util').open(state.tree:get_node().path, { system = true })
            end,
            desc = 'Open with system application',
          },
          ['p'] = { 'toggle_preview', config = { use_float = false } },
        },
      },
      open_files_do_not_replace_types = { 'terminal', 'Trouble', 'trouble', 'qf', 'Outline' },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        window = {
          mappings = {
            ['h'] = 'navigate_up',
            ['l'] = 'set_root',
          },
        },
      },
    },
    keys = {
      { '<Leader>ee', '<Cmd>Neotree toggle left<CR>', desc = 'Toggle Neo-tree (filesystem, left)' },
      { '<Leader>ef', '<Cmd>Neotree focus left<CR>', desc = 'Focus Neo-tree (filesystem)' },
      -- { "<Leader>eq", "<Cmd>Neotree toggle close<CR>", desc = "Close Neo-tree" },
      { '<Leader>eg', '<Cmd>Neotree toggle git_status right<CR>', desc = 'Toggle Git status (right)' },
    },
    deactivate = function()
      vim.cmd [[Neotree close]]
    end,
    init = function()
      -- FIX: Use autocmd for lazy-loading Neo-tree instead of directly requiring it,
      -- because cwd is not set up properly.
      vim.api.nvim_create_autocmd('VimEnter', {
        group = vim.api.nvim_create_augroup('NeoTreeStartFile', { clear = true }),
        desc = 'Start Neo-tree with file',
        once = true,
        callback = function()
          local arg = vim.fn.argv(0)
          local stats = arg and vim.uv.fs_stat(arg)
          -- 仅在不是目录时加载 neo-tree
          if not stats or stats.type ~= 'directory' then
            require 'neo-tree'
          end
        end,
      })
    end,
    default_component_configs = {
      indent = {
        with_expanders = true, -- If nil and file nesting is enabled, will enable expanders
        expander_collapsed = '',
        expander_expanded = '',
        expander_highlight = 'NeoTreeExpander',
      },
      git_status = {
        symbols = {
          unstaged = '󰄱',
          staged = '󰱒',
        },
      },
    },
    config = function(_, opts)
      local function on_move(data)
        snacks.rename.on_rename_file(data.source, data.destination)
      end

      local events = require 'neo-tree.events'
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
      require('neo-tree').setup(opts)
      vim.api.nvim_create_autocmd('TermClose', {
        pattern = '*lazygit',
        callback = function()
          if package.loaded['neo-tree.sources.git_status'] then
            require('neo-tree.sources.git_status').refresh()
          end
        end,
      })
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          -- theme = 'Catppuccin',
          section_separators = '',
          component_separators = '',
          icons_enabled = true,
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
      }
    end,
  },
  {
    'vimpostor/vim-tpipeline',
    config = function()
      -- 自动绑定 vim 状态栏到 tmux
      vim.g.tpipeline_autoembed = 1
      vim.g.tpiptline_restore = 1
      vim.g.tpipeline_clearstl = 1
    end,
  },
  {
    'kdheepak/lazygit.nvim',
    lazy = true,
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit (in the cwd)' },
    },
  },
  ---@type LazySpec
  {
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
  },
}
