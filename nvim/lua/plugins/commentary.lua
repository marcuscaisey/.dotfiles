-- Set the comment characters for the given filetypes
local comment_characters = {
  sql = '--',
  toml = '#',
  please = '#',
}

-- Apply the comment characters for each filetype
local group = vim.api.nvim_create_augroup('commentary', { clear = true })
for filetype, char in pairs(comment_characters) do
  vim.api.nvim_create_autocmd('FileType', {
    callback = function()
      vim.bo.commentstring = char .. '%s'
    end,
    pattern = filetype,
    group = group,
    desc = string.format('Use %s for comments', char),
  })
end
