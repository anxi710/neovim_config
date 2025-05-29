-- lua/custom/plugin/neo-tree.lua

-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
    {
      "s1n7ax/nvim-window-picker", -- for open_with_window_picker keymaps
      version = "2.*",
      config = function()
        require("window-picker").setup({
          filter_rules = {
            include_current_win = false,
            autoselect_one = true,
            -- filter using buffer options
            bo = {
              -- if the file type is one of following, the window will be ignored
              filetype = { "neo-tree", "neo-tree-popup", "notify" },
              -- if the buffer type is one of following, the window will be ignored
              buftype = { "terminal", "quickfix" },
            },
          },
        })
      end,
    },
  },
  lazy = false, -- neo-tree will lazily load itself
  ---@module "neo-tree"
  ---@type neotree.Config?
  opts = {
    close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
    -- popup_border_style = "NC", -- or "" to use 'winborder' on Neovim v0.11+
    -- popup_border_style = "winborder",
    enable_git_status = true,
    enable_diagnostics = true,
    open_files_do_not_replace_types = {
      'terminal',
      'Trouble',
      'trouble',
      'qf',
      'Outline'
    }, -- when opening files, do not use windows containing these filetypes or buftypes
    open_files_using_relative_path = false,
    sort_case_insensitive = false, -- used when sorting files and directories in the tree
    sort_function = nil, -- use a custom function for sorting files and directories in the tree
    -- sort_function = function (a,b)
    --       if a.type == b.type then
    --           return a.path > b.path
    --       else
    --           return a.type > b.type
    --       end
    --   end , -- this sorts files and directories descendantly
    default_component_configs = {
      container = {
        enable_character_fade = true,
      },
      indent = {
        indent_size = 2,
        padding = 1, -- 左侧额外的 padding
        -- indent guides
        with_markers = true,
        indent_marker = "│",
        last_indent_marker = "└",
        highlight = "NeoTreeIndentMarker",
        -- expander config, needed for nesting files
        with_expanders = true, -- If nil and file nesting is enabled, will enable expanders
        expander_collapsed = '',
        expander_expanded = '',
        expander_highlight = 'NeoTreeExpander',
      },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "󰜌",
        provider = function(icon, node, state) -- default icon provider utilizes nvim-web-devicons if available
          if node.type == "file" or node.type == "terminal" then
            local success, web_devicons = pcall(require, "nvim-web-devicons")
            local name = node.type == "terminal" and "terminal" or node.name
            if success then
              local devicon, hl = web_devicons.get_icon(name)
              icon.text = devicon or icon.text
              icon.highlight = hl or icon.highlight
            end
          end
        end,
        -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
        -- then these will never be used.
        default = "*",
        highlight = "NeoTreeFileIcon",
      },
      modified = {
        symbol = "[+]",
        highlight = "NeoTreeModified",
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = false,
        highlight = 'NeoTreeFileName',
      },
      git_status = {
        symbols = {
          -- Change type
          added = '✚', -- or "✚", but this is redundant info if you use git_status_colors on the name
          modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
          deleted = '✖', -- this can only be used in the git_status source
          renamed = '󰁕', -- this can only be used in the git_status source
          -- Status type
          untracked = '',
          ignored = '',
          unstaged = '󰄱',
          staged = '',
          conflict = '',
        },
      },
      -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
      file_size = {
        enabled = true,
        width = 12, -- width of the column
        required_width = 64, -- min width of window required to show this column
      },
      type = {
        enabled = true,
        width = 10, -- width of the column
        required_width = 122, -- min width of window required to show this column
      },
      last_modified = {
        enabled = true,
        width = 20, -- width of the column
        required_width = 88, -- min width of window required to show this column
      },
      created = {
        enabled = true,
        width = 20, -- width of the column
        required_width = 110, -- min width of window required to show this column
      },
      symlink_target = {
        enabled = false,
      },
    },
    -- A list of functions, each representing a global custom command
    -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
    -- see `:h neo-tree-custom-commands-global`
    commands = {},
    window = {
      position = "left",
      width = 30,
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
        -- ['<Esc>'] = 'close_winVdow', -- Use <Esc> to close Neo-tree
        ["<esc>"] = "cancel", -- close preview or floating neo-tree window
        ['l'] = 'open',
        ['h'] = 'close_node',
        ['o'] = {
          function(state)
            require('lazy.util').open(state.tree:get_node().path, { system = true })
          end,
          desc = 'Open with system application',
        },
        ['<cr>'] = 'open_drop',
        ['p'] = { 'toggle_preview', config = { use_float = true, use_image_nvim = true } },
        -- Read `# Preview Mode` for more information
        ["P"] = "focus_preview",
        ['<C-h>'] = 'split_with_window_picker', -- 水平分割
        ['<C-v>'] = 'vsplit_with_window_picker', -- 垂直分割
        ['<C-t>'] = 'open', -- 新 tab 打开
        ['<C-w>'] = 'open_with_window_picker',
        ["a"] = {
          "add",
          -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
          -- some commands may take optional config options, see `:h neo-tree-mappings` for details
          config = {
            show_path = "none", -- "none", "relative", "absolute"
          },
        },
        ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
        ["d"] = "delete",
        ["r"] = "rename",
        ["b"] = "rename_basename",
        ["y"] = "copy_to_clipboard",
        ["x"] = "cut_to_clipboard",
        ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
        ["q"] = "close_window",
        ["R"] = "refresh",
        ["?"] = "show_help",
        ["<"] = "prev_source",
        [">"] = "next_source",
        ["i"] = "show_file_details",
        -- ["i"] = {
        --   "show_file_details",
        --   -- format strings of the timestamps shown for date created and last modified (see `:h os.date()`)
        --   -- both options accept a string or a function that takes in the date in seconds and returns a string to display
        --   -- config = {
        --   --   created_format = "%Y-%m-%d %I:%M %p",
        --   --   modified_format = "relative", -- equivalent to the line below
        --   --   modified_format = function(seconds) return require('neo-tree.utils').relative_date(seconds) end
        --   -- }
        -- },
      },
    },
    filesystem = {
      filtered_items = {
        visible = false, -- when true, they will just be displayed differently than normal items
        hide_dotfiles = true,
        hide_gitignored = true,
        hide_hidden = true, -- only works on Windows for hidden files/directories
        hide_by_name = {
          --"node_modules"
        },
        hide_by_pattern = { -- uses glob style patterns
          --"*.meta",
          --"*/src/*/tsconfig.json",
        },
        always_show = { -- remains visible even if other settings would normally hide it
          --".gitignored",
        },
        always_show_by_pattern = { -- uses glob style patterns
          --".env*",
        },
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          --".DS_Store",
          --"thumbs.db"
        },
        never_show_by_pattern = { -- uses glob style patterns
          --".null-ls_*",
        },
      },
      follow_current_file = {
        enabled = ture, -- This will find and focus the file in the active buffer every time
        --              -- the current file is changed while the tree is open.
        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
      group_empty_dirs = false, -- when true, empty folders will be grouped together
      hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
      -- in whatever position is specified in window.position
      -- "open_current",  -- netrw disabled, opening a directory opens within the
      -- window like netrw would, regardless of window.position
      -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
      use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
      -- instead of relying on nvim autocmd events.
      bind_to_cwd = false,
      window = {
        mappings = {
          ['h'] = 'navigate_up',
          ['l'] = 'set_root',
          ["/"] = "fuzzy_finder",
          ["D"] = "fuzzy_finder_directory",
          ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
          -- ["D"] = "fuzzy_sorter_directory",
          ["f"] = "filter_on_submit",
          ["<c-x>"] = "clear_filter",
          ["[g"] = "prev_git_modified",
          ["]g"] = "next_git_modified",
          ["s"] = {
            "show_help",
            nowait = false,
            config = { title = "Order by", prefix_key = "o" },
          },
          ["sc"] = { "order_by_created", nowait = false },
          ["sd"] = { "order_by_diagnostics", nowait = false },
          ["sg"] = { "order_by_git_status", nowait = false },
          ["sm"] = { "order_by_modified", nowait = false },
          ["sn"] = { "order_by_name", nowait = false },
          ["ss"] = { "order_by_size", nowait = false },
          ["st"] = { "order_by_type", nowait = false },
        },
        fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
          ["<down>"] = "move_cursor_down",
          ["<C-n>"] = "move_cursor_down",
          ["<up>"] = "move_cursor_up",
          ["<C-p>"] = "move_cursor_up",
          ["<esc>"] = "close",
          -- ['<key>'] = function(state, scroll_padding) ... end,
        },
      },
    },
    buffers = {
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
                        -- the current file is changed while the tree is open.
        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
      group_empty_dirs = true, -- when true, empty folders will be grouped together
      show_unloaded = true,
      window = {
        mappings = {
          ["d"] = "buffer_delete",
          ["bd"] = "buffer_delete",
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["s"] = {
            "show_help",
            nowait = false,
            config = { title = "Order by", prefix_key = "o" },
          },
          ["sc"] = { "order_by_created", nowait = false },
          ["sd"] = { "order_by_diagnostics", nowait = false },
          ["sm"] = { "order_by_modified", nowait = false },
          ["sn"] = { "order_by_name", nowait = false },
          ["ss"] = { "order_by_size", nowait = false },
          ["st"] = { "order_by_type", nowait = false },
        },
      },
    },
    git_status = {
      window = {
        position = "float",
        mappings = {
          ["A"] = "git_add_all",
          ["gu"] = "git_unstage_file",
          ["ga"] = "git_add_file",
          ["gr"] = "git_revert_file",
          ["gc"] = "git_commit",
          ["gp"] = "git_push",
          ["gg"] = "git_commit_and_push",
          ["s"] = {
            "show_help",
            nowait = false,
            config = { title = "Order by", prefix_key = "o" },
          },
          ["sc"] = { "order_by_created", nowait = false },
          ["sd"] = { "order_by_diagnostics", nowait = false },
          ["sm"] = { "order_by_modified", nowait = false },
          ["sn"] = { "order_by_name", nowait = false },
          ["ss"] = { "order_by_size", nowait = false },
          ["st"] = { "order_by_type", nowait = false },
        },
      },
    },
    open_file_in_new_window = false, -- 不强制新窗口打开
    event_handlers = {
      { -- 在打开文件时自动关闭上一个 buffer
        event = "file_opened",
        handler = function(file_path)
          -- 自动关闭 Neo-tree
          -- require("neo-tree.command").execute({ action = "close" })
          -- 自动关闭其他 buffer
          vim.cmd("bdelete #")
        end,
      },
    }
  },
  config = function(_, opts)
    local function on_move(data) -- 自动检查文件移动和重命名事件
      snacks.rename.on_rename_file(data.source, data.destination)
    end

    local events = require 'neo-tree.events'
    opts.event_handlers = opts.event_handlers or {}
    vim.list_extend(opts.event_handlers, {
      { event = events.FILE_MOVED, handler = on_move },
      { event = events.FILE_RENAMED, handler = on_move },
    })

    require('neo-tree').setup(opts)

    -- 在使用 LazyGit 之后自动刷新 Git 状态
    vim.api.nvim_create_autocmd('TermClose', {
      pattern = '*lazygit',
      callback = function()
        if package.loaded['neo-tree.sources.git_status'] then
          require('neo-tree.sources.git_status').refresh()
        end
      end,
    })
  end,
  keys = {
    { '<Leader>ee', '<Cmd>Neotree toggle left<CR>', desc = 'Toggle Neo-tree (filesystem, left)' },
    { '<Leader>ef', '<Cmd>Neotree focus left<CR>', desc = 'Focus Neo-tree (filesystem)' },
    -- { "<Leader>eq", "<Cmd>Neotree toggle close<CR>", desc = "Close Neo-tree" },
    { '<Leader>eg', '<Cmd>Neotree toggle git_status right<CR>', desc = 'Toggle Git status (right)' },
    { '\\',         '<Cmd>Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  deactivate = function()
    vim.cmd [[Neotree close]]
  end,
}
