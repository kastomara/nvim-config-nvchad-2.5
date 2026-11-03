local runner = require('runner')
local M = {}

local function project(cmake, make)
  local root = vim.fs.root(0, { 'CMakeLists.txt', 'Makefile' })
  if not root then
    vim.notify('Нет CMakeLists.txt или Makefile', vim.log.levels.WARN)
    return
  end
  local use_cmake = vim.uv.fs_stat(root .. '/CMakeLists.txt')
  runner.in_dir(root, use_cmake and cmake or make)
end

function M.setup(compiler)
  vim.opt_local.shiftwidth = 4
  vim.opt_local.softtabstop = 4

  runner.map('<leader>xr', function()
    runner.single(compiler)
  end, 'Build and run file')

  runner.map('<leader>xb', function()
    project(
      'cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && cmake --build build',
      'make'
    )
  end, 'Build project')

  runner.map('<leader>xt', function()
    project('ctest --test-dir build --output-on-failure', 'make test')
  end, 'Test project')

  -- переключение .c/.cpp <-> .h/.hpp средствами clangd
  runner.map('<leader>cs', function()
    local client = vim.lsp.get_clients({ bufnr = 0, name = 'clangd' })[1]
    if not client then
      return
    end
    client:request(
      'textDocument/switchSourceHeader',
      vim.lsp.util.make_text_document_params(0),
      function(_, result)
        if result then
          vim.cmd.edit(vim.uri_to_fname(result))
        else
          vim.notify('Парный файл не найден')
        end
      end,
      0
    )
  end, 'Switch source/header')
end

return M