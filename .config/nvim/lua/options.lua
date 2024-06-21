local HOME = os.getenv('HOME')

-- Make sure the annoying backup files, swap files, and undo files stay out of
-- the code directories.
vim.opt.backupdir = HOME .. '/.config/nvim/backup'
vim.opt.directory = HOME .. '/.config/nvim/swap'
vim.opt.undodir = HOME .. '/.config/nvim/undo'

-- Enable basic indentation, smarter than "smart"indent
vim.opt.autoindent = true
-- Highlight the current line
vim.opt.cursorline = true
-- Start searching as we start typing
vim.opt.incsearch = true
-- Highlight what we're searching for
vim.opt.hlsearch = true
-- Always show the currently entered command
vim.opt.showcmd = true
-- Make a backup before overwriting a file
vim.opt.writebackup = true
-- Make vim more responsive
vim.opt.ttyfast = true
-- Don't show intermediate macro steps
vim.opt.lazyredraw = true
-- Auto wrap comments at 80 chars
vim.opt.textwidth = 80
-- Allow buffer switching without saving
vim.opt.hidden = true
-- No point since we use lualine
vim.opt.showmode = false
-- Ensure we have a buffer of 5 lines at the top and bottom
vim.opt.scrolloff = 5
-- Enable mouse support
vim.opt.mouse = 'a'

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Default tab settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- invisible character representations
vim.opt.list = true
vim.opt.listchars = { tab = '▸ ', trail = '·' }

