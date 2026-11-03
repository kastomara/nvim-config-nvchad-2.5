return {
  settings = {
    ['rust-analyzer'] = {
      check = { command = 'clippy' }, -- вместо cargo check
      cargo = { allFeatures = true },
    },
  },
}