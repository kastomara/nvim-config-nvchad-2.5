-- Плагин для создания визуальных маркеров важных комментариев
vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim', -- зависимость
  'https://github.com/folke/todo-comments.nvim',
})

local todo = require('todo-comments')

todo.setup({
  signs = true,
  sign_priority = 8,
  keywords = {
    FIX = {
      --icon = '\u{f188}',
      color = '#F38BA8',
      alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE', 'CRITICAL', 'BLOCKER', 'P0' },
    },
    HIGH = {
      icon = '\u{f002a}',
      color = '#FAB387',
      alt = { 'URGENT', 'IMPORTANT', 'PRIORITY', 'P1', 'ASAP' },
    },
    TODO = {
      --icon = '\u{f00c}',
      color = '#89B4F4',
      alt = { 'TASK', 'P2', 'WIP' },
    },
    HACK = {
      --icon = '\u{f06d}',
      color = '#F9E2AF',
      alt = { 'WARN', 'WARNING', 'XXX', 'TEMP', 'P3', 'AUDIT' },
    },
    PERF = {
      --icon = '\u{f017}',
      color = '#CBA6F7',
      alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE', 'BENCH' },
    },
    NOTE = {
      --icon = '\u{f249}',
      color = '#A6E3A1',
      alt = { 'INFO', 'DOCS', 'LOW', 'P4', 'IDEA' },
    },
  },
  gui_style = {
    fg = 'BOLD',
    bg = 'BOLD',
  },
  merge_keywords = true,
  highlights = {
    multiline = true,
    multiline_pattern = '^.',
    multiline_context = 10,
    before = 'fg',
    keyword = 'wide_bg', -- яркая обводка вокруг ключевого слова
    after = 'fg',
    -- Поддержка только "NOTE: text", метки с контекстом "TODO(P1): text" не распознаются
    pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
    comments_only = true,
    max_line_len = 400,
  },
  search = {
    command = 'rg',
    args = {
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
    },
    pattern = [=[\b(KEYWORDS)(?:\([^)]*\))?:]=],
  },
})

local map = vim.keymap.set
local priority_keywords = {
  'FIX',
  'FIXME',
  'BUG',
  'FIXIT',
  'ISSUE',
  'CRITICAL',
  'BLOCKER',
  'P0',
  'HIGH',
  'URGENT',
  'IMPORTANT',
  'PRIORITY',
  'P1',
  'ASAP',
}

-- Навигация по всем меткам
map('n', ']t', function()
  todo.jump_next()
end, { desc = 'Next todo comment' })

map('n', '[t', function()
  todo.jump_prev()
end, { desc = 'Previous todo comment' })

-- Навигация по меткам P0 и P1
map('n', ']T', function()
  todo.jump_next({ keywords = priority_keywords })
end, { desc = 'Next PRIORITY todo' })
map('n', '[T', function()
  todo.jump_prev({ keywords = priority_keywords })
end, { desc = 'Prev PRIORITY todo' })

-- Поиск через FZF
map('n', '<leader>fT', '<cmd>TodoFzfLua<cr>', { desc = 'FZF Todos' })
map(
  'n',
  '<leader>lt',
  '<cmd>Trouble todo toggle<cr>',
  { desc = 'Todos (Trouble)' }
)
