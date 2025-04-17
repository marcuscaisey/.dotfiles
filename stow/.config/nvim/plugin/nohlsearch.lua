local timeout_millis = 3000

local function nohlsearch()
  vim.schedule(function()
    vim.cmd.nohlsearch()
  end)
end

local timer = assert(vim.uv.new_timer())
---@param timeout_millis integer
local function schedule_nohlsearch(timeout_millis)
  timer:start(timeout_millis, 0, nohlsearch)
end

local augroup = vim.api.nvim_create_augroup('nohlsearch', { clear = true })

vim.api.nvim_create_autocmd('InsertEnter', {
  group = augroup,
  desc = ':nohlsearch',
  callback = nohlsearch,
})

vim.api.nvim_create_autocmd('CursorHold', {
  group = augroup,
  desc = string.format(':nohlsearch after %dms', timeout_millis - vim.opt.updatetime:get()),
  callback = function()
    schedule_nohlsearch(timeout_millis - vim.opt.updatetime:get())
  end,
})

for _, key in ipairs({ 'n', 'N' }) do
  vim.keymap.set('n', key, function()
    schedule_nohlsearch(timeout_millis)
    return key
  end, { expr = true, desc = string.format('schedule :nohlsearch after %dms, then %s', timeout_millis, key) })
end
