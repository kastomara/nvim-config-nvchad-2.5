-- Плагин для отображения стартовой заставки
vim.pack.add({ 'https://github.com/nvim-mini/mini.starter' })

local starter = require('mini.starter')

local LABEL_WIDTH = 28 -- ширина колонки с названиями, дальше идут клавиши

-- Замер времени загрузки плагинов
local start_time = _G._nvim_start_hrtime or vim.uv.hrtime()
local base_clock_ms = _G._nvim_start_hrtime and 0 or (os.clock() * 1000)
local load_time_ms = base_clock_ms

vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    load_time_ms = base_clock_ms + (vim.uv.hrtime() - start_time) / 1e6
    if vim.bo.filetype == 'ministarter' then
      starter.refresh()
    end
  end,
})

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
  local function get_hl(name)
    return vim.api.nvim_get_hl(0, { name = name, link = false })
  end

  local normal = get_hl('Normal')
  local visual = get_hl('Visual')
  local cursorLine = get_hl('CursorLine')
  local func = get_hl('Function')
  local special = get_hl('Special')
  local title = get_hl('Title')
  local comment = get_hl('Comment')

  local accent_fg = func.fg or special.fg or title.fg or normal.fg
  local pill_bg = cursorLine.bg or visual.bg or normal.bg

  vim.api.nvim_set_hl(
    0,
    'StarterKey',
    { fg = accent_fg, bg = pill_bg, bold = true }
  )
  vim.api.nvim_set_hl(0, 'StarterKeyEdge', { fg = pill_bg, bg = 'NONE' })

  vim.api.nvim_set_hl(0, 'MiniStarterHeader', { fg = accent_fg, bold = true })
  vim.api.nvim_set_hl(
    0,
    'MiniStarterSection',
    { fg = title.fg or accent_fg, bold = true }
  )
  vim.api.nvim_set_hl(
    0,
    'MiniStarterItemPrefix',
    { fg = special.fg or accent_fg, bold = true }
  )
  vim.api.nvim_set_hl(
    0,
    'MiniStarterFooter',
    { fg = comment.fg, italic = true }
  )
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

local function pluralize_plugins(n)
  local mod10 = n % 10
  local mod100 = n % 100
  if mod10 == 1 and mod100 ~= 11 then
    return 'плагин'
  elseif mod10 >= 2 and mod10 <= 4 and (mod100 < 12 or mod100 > 14) then
    return 'плагина'
  end
  return 'плагинов'
end

local header = table.concat({
  [[  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗  ]],
  [[  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║  ]],
  [[  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║  ]],
  [[  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║  ]],
  [[  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║  ]],
  [[  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝  ]],
}, '\n')

starter.setup({
  evaluate_single = true,
  header = header,
  footer = function()
    local count = #vim.pack.get()
    local word = pluralize_plugins(count)
    local ms = load_time_ms > 0 and load_time_ms or (os.clock() * 1000)
    return string.format(
      '⚡ %d %s · загружено за %.1f мс',
      count,
      word,
      ms
    )
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
    item('\u{f0425}', 'Выход', { 'q' }, function()
      vim.cmd.qa()
    end),
  },
  content_hooks = {
    starter.gen_hook.adding_bullet('> '),
    keycaps_hook, -- должен идти до aligning, чтобы центровка учла ширину клавиш
    starter.gen_hook.aligning('center', 'center'),
  },
})

-- Быстрый выход по нажатию q
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniStarterOpened',
  callback = function(ev)
    vim.keymap.set('n', 'q', '<cmd>qa<cr>', {
      buffer = ev.buf,
      silent = true,
      nowait = true,
      desc = 'Quit Neovim',
    })
  end,
})
