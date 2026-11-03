-- Красивая строка для отображения tab сессий открытых файлов
vim.pack.add({
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/akinsho/bufferline.nvim',
})

require('bufferline').setup({
  options = {
    mode = 'buffers',
    diagnostics = 'nvim_lsp',
    separator_style = 'thin',
    show_buffer_close_icons = false,
    show_close_icon = false,
    -- сдвигаем вкладки вправо, когда открыто дерево файлов
    offsets = {
      {
        filetype = 'NvimTree',
        text = 'Файлы',
        highlight = 'Directory',
        separator = true,
      },
    },
  },
})

local map = vim.keymap.set
map('n', '<leader>bp', '<cmd>BufferLinePick<cr>', { desc = 'Pick buffer' })
map('n', '<leader>bP', '<cmd>BufferLineTogglePin<cr>', { desc = 'Pin buffer' })
