-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Change leader to a comma
vim.g.mapleader = '='
map('n', '<=>', '<Esc>')

-----------------------------------------------------------
-- Neovim shortcuts
-----------------------------------------------------------

-- Remap common misspells
vim.cmd ':command! WQ wq'
vim.cmd ':command! Wq wq'
vim.cmd ':command! W w'
vim.cmd ':command! Q q'

-- Clear search highlighting with <leader> and c
map('n', '<leader>c', ':nohl<CR>')

-- Reload configuration without restart nvim
map('n', '<leader>r', ':so %<CR>')

-- Fast saving with <leader> and s
map('n', '<leader>s', ':w<CR>')
map('i', '<leader>s', '<C-c>:w<CR>')

-- Close all windows and exit from Neovim with <leader> and q
map('n', '<leader>q', ':qa!<CR>')

-----------------------------------------------------------
-- Moving around windows and buffers
-----------------------------------------------------------

-- Buffer moving
map('n', '<C-p>', ':bp<CR>', { silent = true })
map('n', '<C-n>', ':bn<CR>', { silent = true })
map('n', '<C-x>', ':bp<bar>sp<bar>bn<bar>bd<CR>', { silent = true })

-- Tmux navigator
map('n', '<C-Down>', ':TmuxNavigateDown<CR>')
map('n', '<C-Up>', ':TmuxNavigateUp<CR>')
map('n', '<C-Left>', ':TmuxNavigateLeft<CR>')
map('n', '<C-Right>', ':TmuxNavigateRight<CR>')

-----------------------------------------------------------
-- Applications and Plugins shortcuts
-----------------------------------------------------------

-- Terminal mappings
map('n', '<C-t>', ':Term<CR>', { noremap = true })  -- open
map('t', '<Esc>', '<C-\\><C-n>')                    -- exit

-- NvimTree
map('n', '<C-n>', ':NvimTreeToggle<CR>')            -- open/close
map('n', '<leader>f', ':NvimTreeRefresh<CR>')       -- refresh
map('n', '<leader>n', ':NvimTreeFindFile<CR>')      -- search file

-- Tagbar
map('n', '<leader>z', ':TagbarToggle<CR>')          -- open/close

-------------------------------------------------------------
-- Telescope
-------------------------------------------------------------

map('n', 'tf', '<cmd>lua require("telescope.builtin").find_files()<cr>')
map('n', 'tg', '<cmd>lua require("telescope.builtin").live_grep()<cr>')
map('n', 'tb', '<cmd>lua require("telescope.builtin").buffers()<cr>')
map('n', 'th', '<cmd>lua require("telescope.builtin").help_tags()<cr>')

-- Git
map('n', '<leader>gg', '<cmd>LazyGit<CR>')
