return {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
  on_attach = function(client)
    -- hover отдаём basedpyright, иначе всплывающие подсказки дублируются
    client.server_capabilities.hoverProvider = false
  end,
}
