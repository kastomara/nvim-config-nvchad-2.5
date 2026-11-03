-- Плагин для создания визуальных маркеров важных комментариев
vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim', -- зависимость
  'https://github.com/folke/todo-comments.nvim',
})

local todo = require('todo-comments')

todo.setup({})

vim.keymap.set('n', ']t', function()
  todo.jump_next()
end, { desc = 'Next todo comment' })

vim.keymap.set('n', '[t', function()
  todo.jump_prev()
end, { desc = 'Previous todo comment' })

vim.keymap.set('n', '<leader>fT', '<cmd>TodoFzfLua<cr>', { desc = 'FZF Todos' })
vim.keymap.set(
  'n',
  '<leader>lt',
  '<cmd>Trouble todo toggle<cr>',
  { desc = 'Todos (Trouble)' }
)
