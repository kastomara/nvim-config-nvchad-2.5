local runner = require('runner')

runner.map('<leader>xr', function()
  runner.run('Rscript ' .. vim.fn.shellescape(vim.fn.expand('%:p')))
end, 'Rscript file')

-- отправить текущую строку в консоль
runner.map(
  '<leader>xl',
  '<cmd>ToggleTermSendCurrentLine<CR>',
  'Send current line to REPl'
)

runner.map('<leader>xi', function()
  local Terminal = require('toggleterm.terminal').Terminal
  if not _G._r_repl_term then
    _G._r_repl_term = Terminal:new({
      cmd = 'R --no-save',
      direction = 'float',
      hidden = true,
    })
  end
  _G._r_repl_term:toggle()
end, 'Toogle interactive REPL')

-- выделите строки и отправьте в открытую R-консоль (<C-t>, затем R)
vim.keymap.set('x', '<leader>xs', ':ToggleTermSendVisualLines<CR>', {
  buffer = true,
  silent = true,
  desc = 'Send selection to terminal',
})
