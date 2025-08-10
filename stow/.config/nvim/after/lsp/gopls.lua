---@param plz_root string
---@return string? goroot
---@return string? errmsg
local function plz_goroot(plz_root)
  local gotool = 'go'
  local gotool_res = vim.system({ 'plz', '--repo_root', plz_root, 'query', 'config', 'plugin.go.gotool' }):wait()
  if gotool_res.code == 0 then
    gotool = vim.trim(gotool_res.stdout)
  elseif not gotool_res.stderr:match('Settable field not defined') then
    return nil, string.format('querying value of plugin.go.gotool: %s', gotool_res.stderr)
  end

  if vim.startswith(gotool, ':') or vim.startswith(gotool, '//') then
    gotool = gotool:gsub('|go$', '')
    local gotool_output_res = vim.system({ 'plz', '--repo_root', plz_root, 'query', 'output', gotool }):wait()
    if gotool_output_res.code > 0 then
      return nil, string.format('querying output of plugin.go.gotool target "%s": %s', gotool, gotool_output_res.stderr)
    end
    local rel_goroot = vim.trim(gotool_output_res.stdout)
    local goroot = vim.fs.joinpath(plz_root, rel_goroot)
    if not vim.uv.fs_stat(goroot) then
      vim.notify(
        string.format('GOROOT "%s" for Please repo "%s" does not exist. Building plugin.go.gotool target "%s" to create it.', rel_goroot, plz_root, gotool),
        vim.log.levels.INFO
      )
      local out = vim.system({ 'plz', '--repo_root', plz_root, 'build', gotool }):wait()
      if out.code == 0 then
        vim.notify(string.format('Built plugin.go.gotool target "%s" successfully.', gotool), vim.log.levels.INFO)
      else
        return nil, string.format('building plugin.go.gotool target "%s": %s', gotool, out.stderr)
      end
    end
    return goroot
  end

  if vim.startswith(gotool, '/') then
    if not vim.uv.fs_stat(gotool) then
      return nil, string.format('plugin.go.gotool "%s" does not exist', gotool)
    end
    local goroot_res = vim.system({ gotool, 'env', 'GOROOT' }):wait()
    if goroot_res.code == 0 then
      return vim.trim(goroot_res.stdout)
    else
      return nil, string.format('%s env GOROOT: %s', gotool, goroot_res.stderr)
    end
  end

  local build_paths_res = vim.system({ 'plz', '--repo_root', plz_root, 'query', 'config', 'build.path' }):wait()
  if build_paths_res.code > 0 then
    return nil, string.format('querying value of build.path: %s', build_paths_res.stderr)
  end
  local build_paths = vim.trim(build_paths_res.stdout)
  for build_path in vim.gsplit(build_paths, '\n') do
    for build_path_part in vim.gsplit(build_path, ':') do
      local go = vim.fs.joinpath(build_path_part, gotool)
      if vim.uv.fs_stat(go) then
        local goroot_res = vim.system({ go, 'env', 'GOROOT' }):wait()
        if goroot_res.code == 0 then
          return vim.trim(goroot_res.stdout)
        else
          return nil, string.format('%s env GOROOT: %s', go, goroot_res.stderr)
        end
      end
    end
  end

  return nil, string.format('plugin.go.gotool "%s" not found in build.path "%s"', gotool, build_paths:gsub('\n', ':'))
end

---@type vim.lsp.Config
return {
  cmd = function(dispatchers)
    local filename = vim.api.nvim_buf_get_name(0)
    local config = vim.lsp.config.gopls
    local plz_root = vim.fs.root(filename, '.plzconfig')
    if plz_root then
      local goroot, err = plz_goroot(plz_root)
      if goroot then
        config = vim.deepcopy(config)
        config.cmd_env = config.cmd_env or {}
        config.cmd_env.GOROOT = goroot
      else
        vim.notify(string.format('Determining GOROOT for Please repo "%s": %s', plz_root, err), vim.log.levels.WARN)
      end
    end
    return vim.lsp.rpc.start({ 'gopls' }, dispatchers, {
      cwd = config.cmd_cwd,
      env = config.cmd_env,
      detached = config.detached,
    })
  end,
  settings = {
    gopls = {
      semanticTokens = true,
      semanticTokenTypes = {
        string = false,
      },
    },
  },
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('gopls_organize_imports' .. bufnr, {}),
      buffer = bufnr,
      desc = 'Run gopls source.organizeImports code action',
      callback = function()
        local params = vim.lsp.util.make_range_params(0, client.offset_encoding) ---@type lsp.CodeActionParams
        params.context = { only = { 'source.organizeImports' }, diagnostics = {} }
        local resp = client:request_sync('textDocument/codeAction', params, nil, bufnr)
        if not resp or not resp.result then
          return
        end
        for _, code_action in pairs(resp.result) do
          if code_action.edit then
            vim.lsp.util.apply_workspace_edit(code_action.edit, client.offset_encoding)
          end
        end
      end,
    })
  end,
}
