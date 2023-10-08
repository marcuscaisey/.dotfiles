if not vim.g.loaded_camelcasemotion then
  return
end
vim.fn['camelcasemotion#CreateMotionMappings']('<leader>')
