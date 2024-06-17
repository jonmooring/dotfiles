-- Set leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Easier splits
vim.keymap.set('n', '<leader>|', ':vsplit<cr>')
vim.keymap.set('n', '<leader>-', ':split<cr>')

-- Buffer control
vim.keymap.set('n', '<leader>l', ':bnext<cr>')
vim.keymap.set('n', '<leader>h', ':bprev<cr>')
vim.keymap.set('n', '<leader>q', ':bd<cr>')

-- Resizing panes
vim.keymap.set('n', '<M-Up>', '<C-w>+')
vim.keymap.set('n', '<M-Down>', '<C-w>-')
vim.keymap.set('n', '<M-Left>', '<C-w><')
vim.keymap.set('n', '<M-Right>', '<C-w>>')

-- Move lines up and down
vim.keymap.set('n', '<M-j>', ':m .+1<cr>==')
vim.keymap.set('n', '<M-k>', ':m .-2<cr>==')
vim.keymap.set('i', '<M-j>', '<esc>:m .+1<cr>==gi')
vim.keymap.set('i', '<M-k>', '<esc>:m .-2<cr>==gi')
vim.keymap.set('v', '<M-j>', ':m \'>+1<cr>gv=gv')
vim.keymap.set('v', '<M-k>', ':m \'<-2<cr>gv=gv')

-- Project search using telescope
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', telescope.git_files)
vim.keymap.set('n', '<leader>pf', telescope.find_files)
vim.keymap.set('n', '<leader>pg', telescope.live_grep)
