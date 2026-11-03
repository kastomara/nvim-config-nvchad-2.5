# Конфиг Neovim

Личный конфиг Neovim 0.12+ для macOS. Используются встроенные возможности редактора (`vim.pack`, нативный LSP и автодополнение, Treesitter), а плагины подключены только там, где встроенного не хватает. Основной сценарий: Python, C/C++, Rust, R, Lua, веб. Может обновляться.

Конфиг основан на [s3rgeym/nvim-config](https://github.com/s3rgeym/nvim-config), подробности в разделе [Благодарности](#благодарности).

## Содержание

- [Требования](#требования)
- [Установка](#установка)
- [Структура](#структура)
- [Плагины](#плагины)
- [Языки](#языки)
- [Сочетания клавиш](#сочетания-клавиш)
- [Русская раскладка](#русская-раскладка)
- [Alacritty и Zellij](#alacritty-и-zellij)
- [Если что-то не работает](#если-что-то-не-работает)
- [Благодарности](#благодарности)

## Требования

- Neovim **0.12** или новее.
- [Nerd Font](https://www.nerdfonts.com/), на скриншотах `JetBrains Mono Nerd Font`.
- `git`, `fzf`, `ripgrep`.
- `tree-sitter-cli`: без него парсеры не собираются.
- Node.js: нужен Mason и `markdown-preview.nvim`.
- Необязательно: `lazygit` (бинд `<leader>gg`).

```sh
brew install neovim fzf ripgrep tree-sitter-cli node lazygit
```

Инструменты для языков:

```sh
# Python
brew install python uv

# C / C++
xcode-select --install
brew install cmake

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup component add rust-analyzer

# R
echo 'options(repos = c(CRAN = "https://cloud.r-project.org"))' > ~/.Rprofile
R -e 'install.packages(c("languageserver", "styler"))'
```

## Установка

```sh
git clone <URL-репозитория> ~/.config/nvim
nvim
```

При первом запуске `vim.pack` сам скачает плагины. Дождитесь, пока в нижней строке пропадёт сообщение `vim.pack: Installing plugins`, и не закрывайте редактор раньше. Языковые серверы, форматеры и линтеры ставятся через Mason (`:MasonInstall <имя>` или `<leader>m`). Парсеры Treesitter ставятся командой `:TSInstall <язык>`.

Все средства разработки лежат в `~/.local/share/nvim`, поэтому, чтобы полностью сбросить установку, достаточно удалить этот каталог.

## Структура

```
init.lua                  порядок подключения базовых модулей
filetype.lua              свои типы файлов (zsh → bash)
lua/
  options.lua             настройки редактора и русская раскладка
  keymaps.lua             общие сочетания клавиш
  autocmds.lua            автокоманды
  statusline.lua          строка состояния
  theme.lua               сохранение выбранной темы
  current-theme.lua       текущая тема (генерируется)
  runner.lua              запуск команд в терминале
  c_family.lua            общие сочетания для C и C++
plugin/                   настройка плагинов, грузится автоматически
after/
  lsp/                    настройки языковых серверов
  ftplugin/               настройки под конкретные языки
```

Правила простые: каждый плагин настраивается в отдельном файле в `plugin/`, а каждый языковой сервер в `after/lsp/<имя>.lua`. Файлы из `after/lsp` рекурсивно объединяются со встроенными настройками nvim-lspconfig.

## Плагины

| Область | Плагины |
|---|---|
| Менеджер плагинов | встроенный `vim.pack` |
| Файлы | `nvim-tree.lua`, `nvim-web-devicons` |
| Поиск | `fzf-lua` |
| Git | `gitsigns.nvim` |
| Подсветка и объекты | `nvim-treesitter`, `nvim-treesitter-textobjects`, `nvim-treesitter-context` |
| LSP | `nvim-lspconfig`, `mason.nvim`, `mason-lspconfig.nvim` |
| Форматирование | `conform.nvim` |
| Интерфейс | `which-key.nvim`, `bufferline.nvim`, `mini.starter`, `indent-blankline.nvim`, `nvim-colorizer.lua`, `trouble.nvim`, `todo-comments.nvim` |
| Редактирование | `mini.pairs` |
| Терминал | `toggleterm.nvim` |
| Markdown | `markdown-preview.nvim` |
| Темы | catppuccin, tokyonight, nightfox, kanagawa, rose-pine, everforest, onedark, gruvbox-material |

Автодополнение и сниппеты встроенные (`vim.lsp.completion`, `vim.snippet`), отдельных плагинов для них нет.

## Языки

| Язык | LSP | Форматирование | Treesitter |
|---|---|---|---|
| Python | `basedpyright` + `ruff` | `ruff` (fix, format, imports) | `python` |
| C / C++ | `clangd` | `clang-format` через clangd | `c`, `cpp` |
| Rust | `rust_analyzer` (clippy) | `rustfmt` через LSP | `rust` |
| R | `r_language_server` | `styler` | `r` |
| Lua | `lua_ls` | `stylua` | `lua` |
| JS / TS / Vue | `vtsls`, `vue_ls`, `eslint`, `biome` | `biome`, `prettier` | `javascript`, `typescript` |
| Go | `gopls` | `goimports`, `gofmt` | `go` |
| Bash | `bashls` | `shfmt` | `bash` |
| HTML / CSS / JSON | `html`, `cssls`, `jsonls` | `prettier`, `biome` | соответствующие |

Для Python окружение определяется автоматически: активное `VIRTUAL_ENV`, затем `.venv` или `venv` в корне проекта, иначе системный `python3`.

## Сочетания клавиш

Leader это **пробел**. Список доступных продолжений показывается при вводе префикса, полный список текущего буфера открывается по `<leader>?`.

### Основное

| Клавиши | Действие |
|---|---|
| `<leader>w` | сохранить файл |
| `<Esc>` | убрать подсветку поиска |
| `<Tab>` / `<S-Tab>` | предыдущий / следующий буфер |
| `<leader>bd` / `<leader>bD` | закрыть буфер / все остальные |
| `<leader>bn` | новый файл |
| `<leader>bp` / `<leader>bP` | выбрать буфер по букве / закрепить |
| `<C-h/j/k/l>` | переход между окнами (в терминале тоже) |
| `<C-стрелки>` | изменить размер окна |
| `<A-1>`…`<A-9>`, `<A-0>` | вкладки, последняя вкладка |
| `<leader>tn/tc/to/tm` | вкладка: новая / закрыть / оставить одну / переместить |
| `J` / `K` (Visual) | переместить выделенные строки |
| `<leader>r` | заменить слово под курсором (в Visual: выделение) |
| `<leader>ev` | открыть конфиг |
| `<leader>R` | перезапустить nvim |
| `<leader>pu` / `<leader>pc` | обновить плагины / удалить неиспользуемые |

### Файловое дерево

| Клавиши | Действие |
|---|---|
| `<C-n>` | открыть и закрыть дерево |
| `<leader>ef` | показать текущий файл в дереве |
| `g?` (в дереве) | список всех клавиш дерева |

### Поиск (fzf-lua)

| Клавиши | Действие |
|---|---|
| `<leader>ff` | файлы |
| `<leader>fg` / `<leader>fw` | поиск по содержимому / по слову под курсором |
| `<leader>f/` | поиск в текущем буфере |
| `<leader>fb` / `<leader>fo` | буферы / недавние файлы |
| `<leader>fr` | повторить последний поиск |
| `<leader>fs` / `<leader>fS` | символы файла / проекта |
| `<leader>fd` / `<leader>fD` | диагностика проекта / файла |
| `<leader>fm` / `<leader>fj` / `<leader>fq` | метки / переходы / quickfix |
| `<leader>f:` / `<leader>f?` | история команд / поиска |
| `<leader>fk` / `<leader>fh` / `<leader>fc` | клавиши / справка / команды |
| `<leader>fu` | дерево отмен |
| `<leader>ft` | выбор темы с предпросмотром |
| `<leader>fT` | метки TODO по проекту |

### LSP

| Клавиши | Действие |
|---|---|
| `gd` / `gD` | определение / объявление |
| `grr` / `gri` / `grt` | использования / реализации / тип |
| `gra` | code action |
| `grn` | переименовать |
| `K` | документация |
| `<C-Space>` | вызвать автодополнение |
| `<C-k>` | сигнатура функции |
| `<Tab>` / `<S-Tab>` | выбор в меню или переход по полям сниппета |
| `<leader>th` | подсказки типов (inlay hints) |
| `<leader>cf` | форматировать |
| `<leader>m` | Mason |

### Git

| Клавиши | Действие |
|---|---|
| `]c` / `[c` | следующий / предыдущий hunk |
| `<leader>hs` / `<leader>hr` | stage / reset hunk |
| `<leader>hS` / `<leader>hR` | stage / reset весь буфер |
| `<leader>hp` / `<leader>hi` | предпросмотр hunk |
| `<leader>hb` | blame строки |
| `<leader>hd` / `<leader>hD` | diff с индексом / с родительским коммитом |
| `<leader>hq` / `<leader>hQ` | hunks в quickfix |
| `<leader>tb` / `<leader>tw` | blame строки / word diff |
| `ih` | текстовый объект hunk |
| `<leader>gf/gs/gc/gb/gd/gh` | файлы, статус, коммиты, ветки, diff, hunks через fzf |
| `<leader>gg` | lazygit |

### Текстовые объекты и навигация по коду

| Клавиши | Действие |
|---|---|
| `am` / `im` | функция целиком / тело функции |
| `ac` / `ic` | класс целиком / тело класса |
| `]m` / `[m` | следующая / предыдущая функция |
| `]]` / `[[` | следующий / предыдущий класс |
| `]t` / `[t` | следующий / предыдущий TODO |

### Терминал, запуск и диагностика

| Клавиши | Действие |
|---|---|
| `<C-t>` | открыть и закрыть терминал |
| `<Esc><Esc>` | выйти из режима ввода в терминале |
| `<leader>xr` | собрать и запустить текущий файл |
| `<leader>xb` | собрать проект (CMake, Make, `cargo build`) |
| `<leader>xt` / `<leader>xT` | тесты файла / проекта |
| `<leader>xc` | `cargo clippy` (Rust) |
| `<leader>xp` | предпросмотр Markdown в браузере |
| `<leader>xs` (Visual) | отправить выделение в терминал |
| `<leader>cs` | переключиться между `.c(pp)` и `.h(pp)` |
| `<leader>ld` / `<leader>lD` | диагностика проекта / файла (Trouble) |
| `<leader>ls` / `<leader>lr` | символы / ссылки LSP |
| `<leader>lq` / `<leader>lt` | quickfix / TODO в Trouble |

Что именно запускает `<leader>xr`:

| Язык | Команда |
|---|---|
| Python | `python file.py` интерпретатором из окружения проекта |
| C / C++ | `clang` / `clang++` с `-Wall -Wextra` и санитайзерами ASan и UBSan, бинарник во `/tmp` |
| Rust | `cargo run` в cargo-проекте, иначе `rustc` |
| R | `Rscript file.R` |

## Русская раскладка

Сочетания работают при любой системной раскладке благодаря `langmap`. Встроенная русская раскладка Neovim включается по `<C-^>` (`Ctrl` + `6`) и нужна только для ввода текста.

## Alacritty и Zellij

В `alacritty.toml` обязательно включите Option как Alt, иначе сочетания с `<A-...>` не заработают:

```toml
[window]
option_as_alt = "Both"
```

Если nvim запущен внутри Zellij, он перехватывает часть сочетаний до редактора. В стандартной раскладке это `Ctrl+n` (изменение размера панелей) и `Ctrl+t` (вкладки). Либо переключайте Zellij в режим `locked` (`Ctrl+g`), либо переназначайте бинды дерева и терминала.

## Если что-то не работает

**`fatal: ambiguous argument 'HEAD'` при старте.** Установка плагина оборвалась и оставила битый клон. Найдите и удалите его:

```sh
for d in ~/.local/share/nvim/site/pack/core/opt/*/; do
  git -C "$d" rev-parse HEAD >/dev/null 2>&1 || echo "битый: $d"
done
rm -rf ~/.local/share/nvim/site/pack/core/opt/<имя>
```
**`:TSInstall` зависает.** Проверьте `:checkhealth nvim-treesitter`. Чаще всего не хватает `tree-sitter-cli`.

**Линтер не работает в Python.** Проверьте `:checkhealth vim.lsp` в открытом `.py` файле, а интерпретатор:

```vim
:lua =vim.lsp.get_clients({ name = 'basedpyright' })[1].config.settings.python.pythonPath
```

**Не работает предпросмотр Markdown.** Выполните `npm install` в `~/.local/share/nvim/site/pack/core/opt/markdown-preview.nvim/app`.

**Нет подсветки в новом языке.** Установите парсер (`:TSInstall <язык>`) и откройте файл заново. Проверка: `:Inspect` и `:InspectTree`.

### Планируется

- Фиксы текущих багов, связанных с R, TODO, форматерами и др..
- Сделать открытие терминала в nvim более удобным
- Добавлять плагины по необходимости. Пока думаю над diffview, flash, mini.surround.
- Возможно добавить Codeium/Copilot

## Благодарности

- **[s3rgeym](https://github.com/s3rgeym)**: автор оригинального конфига [s3rgeym/nvim-config](https://github.com/s3rgeym/nvim-config). Структура (`vim.pack`, плагины в `plugin/`, серверы в `after/lsp/`, Mason, conform, fzf-lua, встроенная русская раскладка и сохранение темы) взята оттуда. Этот репозиторий является его производной версией с дополнениями: дерево файлов вместо Oil, настройки для Python, C/C++, Rust и R, запуск кода из редактора, стартовый экран, trouble, todo-comments и bufferline.
- Авторы плагинов из таблицы выше и команда Neovim.
