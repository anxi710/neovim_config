local M = {}

local function get_ns()
  local ns = vim.api.nvim_get_namespaces()
  return ns and ns['headlines_namespace']
end

local function toggle_headlines_visibility(visible)
  local ns = get_ns()
  if not ns then
    print 'headlines namespace not found'
    return
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == 'markdown' then
      if visible then
        -- 尝试调用 headlines 重新渲染接口，或者简单用 bufload 触发刷新
        vim.schedule(function()
          vim.api.nvim_buf_call(buf, function()
            local ok, headlines = pcall(require, 'headlines')
            if ok and headlines.refresh then
              vim.schedule(function()
                headlines.refresh(buf)
              end)
            end
          end)
        end)
      else
        vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
      end
    end
  end
end

function M.setup()
  vim.api.nvim_create_augroup('HeadlinesModeSwitch', { clear = true })

  vim.api.nvim_create_autocmd('ModeChanged', {
    group = 'HeadlinesModeSwitch',
    pattern = '*',
    callback = function(args)
      -- args.match 格式: from_mode:to_mode
      local from_mode, to_mode = args.match:match '^(%a+):(%a+)$'
      -- print("ModeChanged from:", from_mode, "to:", to_mode)

      if to_mode == 'n' then
        toggle_headlines_visibility(true)
      else
        toggle_headlines_visibility(false)
      end
    end,
  })
end

return M
