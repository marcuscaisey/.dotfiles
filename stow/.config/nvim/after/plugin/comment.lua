local ok, comment = pcall(require, 'Comment')
if not ok then
  return
end

local ft = require('Comment.ft')

ft.lox = '//%s'
ft.ebnf = '/*%s*/'

comment.setup()
