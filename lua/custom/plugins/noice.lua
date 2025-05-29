-- lua/custom/plugins/noice.lua
return {
  -- 优化 Neovim 的消息提示
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
        long_message_to_split = true, -- Long messages will be sent to a split
        -- inc_rename = false, -- Enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- Add a border to hover docs and signature help
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
    -- 使用 snacks.nvim 提供的 notify 功能
    -- 'rcarriga/nvim-notify',
  },
}
