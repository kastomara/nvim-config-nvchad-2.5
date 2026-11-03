-- Самый удобный консольный файловый менеджер для nvim
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.pack.add({
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-tree/nvim-tree.lua',
})

local api = require('nvim-tree.api')

require('nvim-tree').setup({
  hijack_cursor = true,
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = { enable = true }, -- подсвечивать открытый файл в дереве
  view = { width = 35 },
  renderer = {
    group_empty = true,
    indent_markers = { enable = true },
  },
  filters = { dotfiles = false, custom = { '^\\.git$' } },
  git = { ignore = false },
  on_attach = function(bufnr)
    api.config.mappings.default_on_attach(bufnr)
    -- внутри дерева тот же бинд его закрывает
    vim.keymap.set(
      'n',
      '<C-n>',
      api.tree.close,
      { buffer = bufnr, desc = 'Закрыть дерево' }
    )
  end,
})

vim.keymap.set(
  'n',
  '<C-n>',
  '<cmd>NvimTreeToggle<CR>',
  { desc = 'Файловое дерево' }
)
vim.keymap.set(
  'n',
  '<leader>ef',
  '<cmd>NvimTreeFindFile<CR>',
  { desc = 'Показать файл в дереве' }
)

-- закрывать nvim, если дерево осталось последним окном
vim.api.nvim_create_autocmd('BufEnter', {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and vim.bo.filetype == 'NvimTree' then
      vim.cmd('quit')
    end
  end,
})
