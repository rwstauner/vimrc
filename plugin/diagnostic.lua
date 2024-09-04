vim.diagnostic.config({
  float = {
    border = "rounded"
  }
})

-- Open floating window with diagnostics for given line.
vim.keymap.set('n', '<Leader>df', vim.diagnostic.open_float)

-- Populate location list with buffer diagnostics.
vim.keymap.set('n', '<Leader>dl', vim.diagnostic.setloclist)
