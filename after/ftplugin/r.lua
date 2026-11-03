local runner = require('runner')

runner.map('<leader>xr', function()
  runner.run('Rscript ' .. vim.fn.shellescape(vim.fn.expand('%:p')))
end, 'Rscript file')

-- выделите строки и отправьте в открытую R-консоль (<C-t>, затем R)
vim.keymap.set('x', '<leader>xs', ':ToggleTermSendVisualLines<CR>', {
  buffer = true,
  silent = true,
  desc = 'Send selection to terminal',
})
