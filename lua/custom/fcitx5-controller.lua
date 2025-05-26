-- lua/custom/plugins/fcitx5_controller.lua

local M = {}
local uv = vim.loop

-- 记录上一次输入法状态：0 (关闭)，2 (中文开启)
local last_im_state = 0

-- 异步执行命令
local function async_exec(cmd, on_exit)
  local stdout = uv.new_pipe(false)
  local handle
  local output = ''

  handle = uv.spawn('sh', {
    args = { '-c', cmd },
    stdio = { nil, stdout, nil },
  }, function()
    stdout:close()
    handle:close()
    if on_exit then
      on_exit(output)
    end
  end)

  stdout:read_start(function(err, data)
    if err then
      return
    end
    if data then
      output = output .. data
    end
  end)
end

-- 获取输入法状态
local function get_im_state(cb)
  async_exec('fcitx5-remote', function(out)
    local state = tonumber(out) or 0
    cb(state)
  end)
end

function M.setup()
  vim.api.nvim_create_autocmd('InsertLeave', {
    callback = function()
      get_im_state(function(state)
        last_im_state = state
        if state == 2 then
          async_exec 'fcitx5-remote -c'
        end
      end)
    end,
  })

  vim.api.nvim_create_autocmd('InsertEnter', {
    callback = function()
      if last_im_state == 2 then
        async_exec 'fcitx5-remote -o'
      end
    end,
  })
end

local current_im = 'EN' -- 当前输入法状态：EN / CN

-- 周期刷新当前输入法状态
local function update_im_state()
  async_exec('fcitx5-remote', function(out)
    local state = tonumber(out)
    if state == 2 then
      current_im = 'CN'
    else
      current_im = 'EN'
    end
  end)
end

-- 启动定时器定期刷新（每 500 ms）
local timer = uv.new_timer()
timer:start(0, 500, vim.schedule_wrap(update_im_state))

-- 对外暴露状态获取函数
function M.get_current_im()
  return current_im
end

return M
