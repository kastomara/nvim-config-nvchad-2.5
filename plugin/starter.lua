-- Плагин для отображения стартовой заставки
vim.pack.add({ 'https://github.com/nvim-mini/mini.starter' })

local starter = require('mini.starter')

local LABEL_WIDTH = 36 -- ширина колонки с названиями, дальше идут клавиши

local function fzf(name)
  return function()
    require('fzf-lua')[name]()
  end
end

local function new_file()
  vim.ui.input({
    prompt = 'Имя файла (пусто — безымянный буфер): ',
  }, function(name)
    if name and name ~= '' then
      vim.cmd.edit(vim.fn.fnameescape(name))
    else
      vim.cmd.enew()
    end
  end)
end

vim.keymap.set('n', '<leader>bn', new_file, { desc = 'New file' })

-- Подсветка клавиш: фон берём у текущей темы
local function setup_hl()
  local normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
  local visual = vim.api.nvim_get_hl(0, { name = 'Visual', link = false })
  vim.api.nvim_set_hl(
    0,
    'StarterKey',
    { fg = normal.fg, bg = visual.bg, bold = true }
  )
  vim.api.nvim_set_hl(0, 'StarterKeyEdge', { fg = visual.bg })
end

setup_hl()
vim.api.nvim_create_autocmd('ColorScheme', { callback = setup_hl })

local function item(icon, label, keys, action)
  return {
    name = icon .. '  ' .. label,
    keys = keys,
    action = action,
    section = 'Действия',
  }
end

-- Превращает item.keys в блоки «‹ f ›» справа от названия
local function keycaps_hook(content)
  for _, line in ipairs(content) do
    for i, unit in ipairs(line) do
      local it = unit.type == 'item' and unit.item
      if it and it.keys then
        local pad =
          math.max(LABEL_WIDTH - vim.fn.strdisplaywidth(unit.string), 2)
        local extra =
          { { string = string.rep(' ', pad), type = 'item-bullet' } }
        for _, key in ipairs(it.keys) do
          table.insert(
            extra,
            { string = '\u{e0b6}', type = 'item-bullet', hl = 'StarterKeyEdge' }
          )
          table.insert(extra, {
            string = ' ' .. key .. ' ',
            type = 'item-bullet',
            hl = 'StarterKey',
          })
          table.insert(extra, {
            string = '\u{e0b4} ',
            type = 'item-bullet',
            hl = 'StarterKeyEdge',
          })
        end
        for k, u in ipairs(extra) do
          table.insert(line, i + k, u)
        end
        break
      end
    end
  end
  return content
end

local header = table.concat({
  [[                                           /$$   /$$                ]],
  [[  /$$   /$$  /$$$$$$   /$$$$$$  /$$$$$$$  / $$  /$$$  /$$$$$$/$$$$  ]],
  [[ | $$  | $$ /$$__  $$ /$$__  $$| $$  | $$ | $$ /$$$$ | $$_  $$_  $$ ]],
  [[ | $$  | $$| $$$$$$$$| $$  \ $$| $$$$$$$$ | $$$$/ $$ | $$ \ $$ \ $$ ]],
  [[ | $$$$$$$$| $$_____/| $$  | $$| $$  | $$ | $$$ | $$ | $$ | $$ | $$ ]],
  [[ | $$  | $$|  $$$$$$$|  $$$$$$/| $$$$$$$/ | $$  | $$ | $$ | $$ | $$ ]],
  [[ | $$  | $$ \_______/ \______/  \______/  |__/  |__/ |__/ |__/ |__/ ]],
  [[ | $$  | $$                                                         ]],
  [[ |__/  |__/                                                         ]],
}, '\n')

starter.setup({
  header = header,
  footer = function()
    return #vim.pack.get() .. ' плагинов'
  end,
  items = {
    item('\u{f0214}', 'Новый файл', { '␣', 'b', 'n' }, new_file),
    item('\u{f0349}', 'Найти файл', { '␣', 'f', 'f' }, fzf('files')),
    item(
      '\u{f1da}',
      'Последние файлы',
      { '␣', 'f', 'o' },
      fzf('oldfiles')
    ),
    item(
      '\u{f031}',
      'Найти по слову',
      { '␣', 'f', 'g' },
      fzf('live_grep')
    ),
    item('\u{f02e}', 'Закладки', { '␣', 'f', 'm' }, fzf('marks')),
    item('\u{f1fc}', 'Темы', { '␣', 'f', 't' }, fzf('colorschemes')),
    item(
      '\u{f11c}',
      'Сочетания клавиш',
      { '␣', 'f', 'k' },
      fzf('keymaps')
    ),
    item('\u{f013}', 'Настройки', { '␣', 'e', 'v' }, function()
      vim.cmd.edit(vim.env.MYVIMRC)
    end),
    function()
      local items = starter.sections.recent_files(5, false, false)()
      for _, it in ipairs(items) do
        it.section = 'Недавние файлы'
      end
      return items
    end,
  },
  content_hooks = {
    keycaps_hook, -- должен идти до aligning, чтобы центровка учла ширину клавиш
    starter.gen_hook.aligning('center', 'center'),
  },
})
