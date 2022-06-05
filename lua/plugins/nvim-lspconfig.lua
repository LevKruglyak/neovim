-----------------------------------------------------------
-- Neovim LSP configuration file
-----------------------------------------------------------

-- Plugin: nvim-lspconfig
-- url: https://github.com/neovim/nvim-lspconfig

-- For configuration see the Wiki: https://github.com/neovim/nvim-lspconfig/wiki
-- Autocompletion settings of "nvim-cmp" are defined in plugins/nvim-cmp.lua

local lsp_status_ok, lspconfig = pcall(require, 'lspconfig')
if not lsp_status_ok then
  return
end

local cmp_status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not cmp_status_ok then
  return
end

-- Diagnostic options, see: `:help vim.diagnostic.config`
vim.diagnostic.config({ virtual_text = true })

-- Show line diagnostics automatically in hover window
vim.cmd([[
  autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, { focus = false })
]])

-- Add additional capabilities supported by nvim-cmp
-- See: https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

capabilities.textDocument.completion.completionItem.documentationFormat = { 'markdown', 'plaintext' }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  },
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Highlighting references
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap = true, silent = true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', function() vim.lsp.buf.declaration() end, opts)
  buf_set_keymap('n', 'gd', function() vim.lsp.buf.definition() end, opts)
  buf_set_keymap('n', 'K', function() vim.lsp.buf.hover() end, opts)
  buf_set_keymap('n', 'gi', function() vim.lsp.buf.implementation() end, opts)
  buf_set_keymap('n', '<C-k>', function() vim.lsp.buf.signature_help() end, opts)
  buf_set_keymap('n', '<space>wa', function() vim.lsp.buf.add_workspace_folder() end, opts)
  buf_set_keymap('n', '<space>wr', function() vim.lsp.buf.remove_workspace_folder() end, opts)
  buf_set_keymap('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
  buf_set_keymap('n', '<space>D', function() vim.lsp.buf.type_definition() end, opts)
  buf_set_keymap('n', 'gR', function() vim.lsp.buf.rename() end, opts)
  buf_set_keymap('n', 'gA', function() vim.lsp.buf.code_action() end, opts)
  buf_set_keymap('n', 'gr', function() vim.lsp.buf.references() end, opts)
  buf_set_keymap('n', '<space>e', function() vim.lsp.diagnostic.show_line_diagnostics() end, opts)
  buf_set_keymap('n', '[d', function() vim.lsp.diagnostic.goto_prev() end, opts)
  buf_set_keymap('n', ']d', function() vim.lsp.diagnostic.goto_next() end, opts)
  buf_set_keymap('n', '<space>q', function() vim.lsp.diagnostic.set_loclist() end, opts)
  buf_set_keymap('n', '<space>f', function() vim.lsp.buf.formatting() end, opts)
end

-- Define `root_dir` when needed
-- See: https://github.com/neovim/nvim-lspconfig/issues/320
-- This is a workaround, maybe not work with some servers.
local root_dir = function()
  return vim.fn.getcwd()
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches.
-- Add your language server below:
local servers = { 'bashls', 'pyright', 'clangd', 'html', 'cssls', 'tsserver', 'rust_analyzer' }

-- Call setup
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    root_dir = root_dir,
    capabilities = capabilities,
    flags = {
      -- default in neovim 0.7+
      debounce_text_changes = 150,
    }
  }
end
