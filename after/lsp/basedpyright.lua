-- Маркеры для поиска виртуального окружения
local project_markers = {
  ['.venv'] = true,
  ['venv'] = true,
  ['pyproject.toml'] = true,
  ['setup.py'] = true,
  ['setup.cfg'] = true,
  ['requirements.txt'] = true,
  ['Pipfile'] = true,
  ['pyrightconfig.json'] = true,
}

local function find_python(start)
  local venv = vim.env.VIRTUAL_ENV
  if venv and vim.uv.fs_stat(venv .. '/bin/python') then
    return venv .. '/bin/python'
  end

  if start then
    local dir = vim.fs.find({ '.venv', 'venv' }, {
      path = start,
      upward = true,
      type = 'directory',
    })[1]
    if dir and vim.uv.fs_stat(dir .. '/bin/python') then
      return dir .. '/bin/python'
    end
  end

  return vim.fn.exepath('python3')
end

return {
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, function(name)
      return project_markers[name]
    end) or vim.fs.root(bufnr, '.git')
    on_dir(root or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
  end,
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
