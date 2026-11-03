-- Настройки самих плагинов лежат в after/plugin/ и загружаются стандартным
-- механизмом Neovim
pcall(function()
  require('vim._core.ui2').enable()
end)

require('options')
require('theme')
require('statusline')
require('autocmds')
require('keymaps')
