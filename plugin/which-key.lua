vim.pack.add({ 'https://github.com/folke/which-key.nvim' })

local wk = require('which-key')

wk.setup({
  preset = 'modern',
  spec = {
    { '<leader>b', group = 'Buffers' },
    { '<leader>d', group = 'Debug' },
    { '<leader>f', group = 'Find' },
    { '<leader>h', group = 'Hunks' },
    { '<leader>p', group = 'Plugins' },
    { '<leader>x', group = 'Run' },
    { '<leader>t', group = 'Tabs' },
    { '<leader>g', group = 'Git' },
    { '<leader>l', group = 'LSP' },
    { '<leader>l', group = 'LSP / Trouble' },
  },
})

vim.keymap.set('n', '<leader>?', function()
  wk.show({ global = false })
end, { desc = 'Buffer Local Keymaps (which-key)' })
