local runner = require('runner')

-- внутри cargo-проекта используем cargo, иначе fallback
local function cargo(args, fallback)
  local root = vim.fs.root(0, { 'Cargo.toml' })
  if root then
    runner.in_dir(root, 'cargo ' .. args)
  elseif fallback then
    fallback()
  else
    vim.notify('Cargo.toml не найден', vim.log.levels.WARN)
  end
end

runner.map('<leader>xr', function()
  cargo('run', function()
    runner.single('rustc --edition 2024 -g')
  end)
end, 'Cargo run / rustc file')

runner.map('<leader>xb', function() cargo('build') end, 'Cargo build')
runner.map('<leader>xt', function() cargo('test') end, 'Cargo test')
runner.map('<leader>xc', function() cargo('clippy --all-targets') end, 'Cargo clippy')