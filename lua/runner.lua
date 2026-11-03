local M = {}

function M.run(cmd)
  vim.cmd.write()
  require('toggleterm').exec(cmd)
end

function M.in_dir(dir, cmd)
  M.run(('(cd %s && %s)'):format(vim.fn.shellescape(dir), cmd))
end

-- собрать один файл во /tmp и запустить
function M.single(compiler)
  local src = vim.fn.shellescape(vim.fn.expand('%:p'))
  local bin = vim.fn.shellescape('/tmp/nvim-run/' .. vim.fn.expand('%:t:r'))
  M.run(
    ('mkdir -p /tmp/nvim-run && %s %s -o %s && %s'):format(
      compiler,
      src,
      bin,
      bin
    )
  )
end

function M.map(lhs, fn, desc)
  vim.keymap.set('n', lhs, fn, { buffer = true, desc = desc })
end

return M