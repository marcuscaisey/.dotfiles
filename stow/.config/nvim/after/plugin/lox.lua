for _, plugin in ipairs(vim.pack.get()) do
  if plugin.spec.name == 'lox' then
    vim.opt.runtimepath:append(vim.fs.joinpath(plugin.path, 'tree-sitter-lox'))
  end
end
