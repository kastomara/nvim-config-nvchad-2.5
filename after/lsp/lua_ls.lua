return {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = { 'lua/?.lua', 'lua/?/init.lua' },
      },
      diagnostics = {
        globals = { 'vim' },
        disable = {
          'lowercase-global',
          'param-type-mismatch',
          'undefined-doc-name',
        },
      },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file('', true),
      },
      format = { enable = false },
      telemetry = { enable = false },
    },
  },
}
