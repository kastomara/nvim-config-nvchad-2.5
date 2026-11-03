-- Плагин для защиты от error code situation
vim.pack.add({ 'https://github.com/folke/trouble.nvim' })

require('trouble').setup({})

local map = vim.keymap.set
map(
  'n',
  '<leader>ld',
  '<cmd>Trouble diagnostics toggle<cr>',
  { desc = 'Diagnostics (project)' }
)
map(
  'n',
  '<leader>lD',
  '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
  { desc = 'Diagnostics (buffer)' }
)
map(
  'n',
  '<leader>ls',
  '<cmd>Trouble symbols toggle focus=false<cr>',
  { desc = 'Symbols' }
)
map(
  'n',
  '<leader>lr',
  '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
  { desc = 'LSP refs/defs' }
)
map('n', '<leader>lq', '<cmd>Trouble qflist toggle<cr>', { desc = 'Quickfix' })
