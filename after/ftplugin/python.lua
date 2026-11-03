local runner = require('runner')

local function python()
  local client = vim.lsp.get_clients({ bufnr = 0, name = 'basedpyright' })[1]
  local py = client
      and vim.tbl_get(client, 'config', 'settings', 'python', 'pythonPath')
    or 'python3'
  return vim.fn.shellescape(py)
end

local function file()
  return vim.fn.shellescape(vim.fn.expand('%:p'))
end

local function run(cmd)
  vim.cmd.write()
  require('toggleterm').exec(cmd)
end

local function map(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { buffer = true, desc = desc })
end

map('<leader>xr', function()
  run(python() .. ' ' .. file())
end, 'Python: run file')
map('<leader>xt', function()
  run(python() .. ' -m pytest -x ' .. file())
end, 'Python: pytest file')
map('<leader>xT', function()
  run(python() .. ' -m pytest -x')
end, 'Python: pytest project')
