require('plugins')
require('options')
require('keybindings')

-- If clipboard is available, do everything we can to yank to the system
-- clipboard rather than only the internal keyboard.
if vim.fn.has('clipboard') == 1 then
  if vim.fn.has('unnamedplus') == 1 then
    -- When possible use + register for copy-paste
    vim.opt.clipboard = "unnamedplus"
  else
    -- On mac and Windows, use * register for copy-paste
    vim.opt.clipboard = "unnamed"
  end
end


-- Disable relative numbers in insert mode and disable absolute numbers in visual mode
vim.api.nvim_create_autocmd('ModeChanged', {
  callback = function(event)
    vim.opt.number = true
    vim.opt.relativenumber = true

    if string.match(event.match, ":i$") then
      vim.opt.relativenumber = false
    elseif string.match(event.match, ":v$") then
      vim.opt.number = false
    end
  end
})

-- Highlight conflict markers
vim.cmd([[match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$']])

