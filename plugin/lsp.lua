vim.api.nvim_command('packadd nvim-lspconfig')

local lspconfig = require('lspconfig')
lspconfig.clangd.setup({})
lspconfig.ruby_lsp.setup({})
lspconfig.rust_analyzer.setup({})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    -- Need to wait for info to be available before toggling on.
    vim.fn.timer_start(1000, function ()
      vim.lsp.inlay_hint.enable(true)
    end)

    -- for local mappings use vim.keymap.set(m, k, f, { buffer = true })
    vim.api.nvim_command('cnorea <buffer> LSP lua vim.lsp.buf.')

    -- Change SuperTab to use the list from lsp for this buffer.
    vim.api.nvim_command('call SuperTabSetDefaultCompletionType("<c-x><c-o>")')

    -- TODO: We could get a list of items and pass it to fzf to recreate "FZFTags" with LSP features: https://github.com/junegunn/fzf.vim?tab=readme-ov-file#custom-completion
  end,
})

-- Menu of additional actions provided by lsp.
vim.keymap.set({'n', 'v'}, '<Leader>la', vim.lsp.buf.code_action)

-- Jump to definition.
-- vim.keymap.set({'n', 'v'}, '<Leader>lD', vim.lsp.buf.declaration)
vim.keymap.set({'n', 'v'}, '<Leader>ld', vim.lsp.buf.definition)

-- Make completion function available (but normally just use SuperTab).
vim.keymap.set('i', '<Leader>l<Tab>', vim.lsp.buf.completion)

-- Toggle inlay hints.
vim.keymap.set('n', '<Leader>li', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)

-- Rename an item.
vim.keymap.set('n', '<Leader>ln', vim.lsp.buf.rename)

-- Open references in quickfix.
vim.keymap.set('n', '<Leader>lr', vim.lsp.buf.references)

-- Pop up signature help.
vim.keymap.set('n', '<Leader>ls', vim.lsp.buf.signature_help)

-- Jump to type definition.
vim.keymap.set('n', '<Leader>lt', vim.lsp.buf.type_definition)

-- List all workplace symbols
--vim.keymap.set('n', '<Leader>lws', vim.lsp.buf.workspace_symbol)

-- TODO: setup formatexpr for q motion with vim.lsp.buf.format?
