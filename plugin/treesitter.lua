-- Данный плагин лишь предоставляет команды TSInstall и TSUpdate.
-- `:TSInstall <language>` или `:TSInstall all`.
-- Парсеры можно ставить через vim.pack.add с { load = false }, который лишь выполняет git clone.
-- В арче пакет tree-sitter является зависимостью nvim, поэтому tree-sitter ставить не нужно.
vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter' })

-- Тут можно указать предстановленные парсеры
-- https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
require('nvim-treesitter').install({
  'bash',
  'c',
  'cmake',
  'cpp',
  'dockerfile',
  'lua',
  'luadoc',
  'make',
  'markdown',
  'markdown_inline',
  'python',
  'r',
  'rust',
  'sql',
  'toml',
  'vim',
  'vimdoc',
})

-- Доп сопаставления типов файлов
vim.filetype.add({
  filename = {
    ['Dockerfile'] = 'dockerfile',
    ['Containerfile'] = 'dockerfile',
    ['CMakeLists.txt'] = 'cmake',
    ['Makefile'] = 'make',
    ['GNUmakefile'] = 'make',
  },
  extension = {
    dockerfile = 'dockerfile',
    cmake = 'cmake',
    mk = 'make',
    sql = 'sql',
    toml = 'toml',
    R = 'r',
    r = 'r',
    Rmd = 'rmd',
    qmd = 'quarto',
  },
})

-- Treesitter features for installed languages must be enabled manually
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if lang and pcall(vim.treesitter.language.add, lang) then
      pcall(vim.treesitter.start)

      -- Configure code folding
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo.foldmethod = 'expr'
      vim.wo.foldlevel = 99
    else
      vim.bo[args.buf].syntax = 'ON'
    end
  end,
})

-- Обновление языковых парсеров после обновления Treesitter
-- Без этого они могут сломаться
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' then
      vim.cmd('TSUpdate')
    end
  end,
})
