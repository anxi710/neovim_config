-- lua/custom/plugin/bufferline.lua
return {
  -- 'akinsho/bufferline.nvim',
  -- dependencies = { 'nvim-tree/nvim-web-devicons' },
  -- event = 'VeryLazy',
  -- config = function()
  --   require('bufferline').setup {
  --     options = {
  --       mode = 'buffers',
  --       numbers = 'ordinal',
  --       diagnostics = 'nvim_lsp',
  --       show_buffer_close_icons = true,
  --       show_close_icon = false,
  --       separator_style = 'slant',
  --       always_show_bufferline = true,

  --       -- 过滤 Neo-tree buffer
  --       custom_filter = function(buf_number, _)
  --         local ft = vim.bo[buf_number].filetype
  --         local name = vim.api.nvim_buf_get_name(buf_number)
  --         if ft == 'neo-tree' or name:match 'neo%-tree' then
  --           return false
  --         end
  --         if name == '' or name:match '^term://' then
  --           return false
  --         end
  --         return true
  --       end,

  --       offsets = {
  --         {
  --           filetype = 'neo-tree',
  --           text = 'File Explorer',
  --           hightlight = 'Directory',
  --           text_align = 'center',
  --           separator = true,
  --         },
  --       },
  --     },
  --   }

  --   -- 自动卸载 buffer：关闭 tab 时若 buffer 不再被使用则 bdelete
  --   vim.api.nvim_create_autocmd('TabClosed', {
  --     callback = function(args)
  --       local tabnr = tonumber(args.match)
  --       if not tabnr then return end
  --       local ok, bufs = pcall(vim.fn.tabpagebuflist, tabnr)
  --       if ok and type(bufs) == "table" then
  --         for _, bufnr in ipairs(bufs) do
  --           if vim.fn.bufwinnr(bufnr) == -1 then
  --             vim.cmd('bdelete ' .. bufnr)
  --           end
  --         end
  --       end
  --     end,
  --   })

  -- end,
}
