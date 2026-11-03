vim.pack.add({ 'https://github.com/akinsho/toggleterm.nvim' })

require('toggleterm').setup({
  open_mapping = [[<C-t>]], -- работает и в normal, и внутри терминала
  direction = 'float', -- или 'horizontal' / 'vertical'
  size = 15, -- для horizontal/vertical
  float_opts = { border = 'rounded' },
  shade_terminals = false,
})

-- выход из терминального режима по двойному Esc
vim.keymap.set(
  't',
  '<Esc><Esc>',
  [[<C-\><C-n>]],
  { desc = 'Normal-режим в терминале' }
)

-- бонус: lazygit в отдельном окне (взамен удалённого neogit)
local Terminal = require('toggleterm.terminal').Terminal
local lazygit =
  Terminal:new({ cmd = 'lazygit', direction = 'float', hidden = true })
vim.keymap.set('n', '<leader>gg', function()
  lazygit:toggle()
end, { desc = 'Lazygit' })
