local function find_python(root)
  local venv = vim.env.VIRTUAL_ENV
  if venv and vim.uv.fs_stat(venv .. '/bin/python') then
    return venv .. '/bin/python'
  end

  if root then
    for _, dir in ipairs({ '.venv', 'venv' }) do
      local py = root .. '/' .. dir .. '/bin/python'
      if vim.uv.fs_stat(py) then
        return py
      end
    end
  end

  return vim.fn.exepath('python3')
end

return {
  before_init = function(params, config)
    local root = config.root_dir or params.rootPath
    config.settings = config.settings or {}
    config.settings.python = config.settings.python or {}
    config.settings.python.pythonPath = find_python(root)
  end,
  settings = {
    basedpyright = {
      disableOrganizeImports = true, -- импорты сортирует ruff
      analysis = {
        typeCheckingMode = 'basic',
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'workspace',
        inlayHints = {
          variableTypes = false,
          functionReturnTypes = true,
          callArgumentNames = true,
          genericTypes = false,
        },
      },
    },
  },
}
