local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup({ transparent = true })
      vim.cmd([[colorscheme tokyonight]])
    end
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          "bash",
          "css",
          "dockerfile",
          "graphql",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "prisma",
          "sql",
          "terraform",
          "tmux",
          "toml",
          "typescript",
          "vim",
          "yaml"
        },
        auto_install = true,
        highlight = { enable = true }
      })
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = true
  },
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = true
  },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = true
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true,
    opts = {
      pickers = {
        find_files = {
          find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
        },
        grep_string = {
          additional_args = {'--hidden'}
        },
        live_grep = {
          additional_args = {'--hidden'}
        }
      },
      extensions = {
        file_browser = {
          follow_symlinks = true
        }
      }
    }
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require('telescope').load_extension('file_browser')
    end
  },
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
    },
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },
  },
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    config = true
  },
  {
    'williamboman/mason.nvim',
    config = true
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { "VonHeikemen/lsp-zero.nvim" },
    opts = {
      ensure_installed = {
        'bashls',
        'cssls',
        'dockerls',
        'docker_compose_language_service',
        'eslint',
        'graphql',
        'html',
        'jsonls',
        'lua_ls',
        'prismals',
        'remark_ls',
        'taplo',
        'terraformls',
        'tflint',
        'tsserver',
        'vimls',
        'yamlls'
      },
      handlers = {
        function(server_name)
          require('lspconfig')[server_name].setup({})
        end,
      },
    }
  },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    config = function()
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()

      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({buffer = bufnr})
      end)
    end
  },
  {'neovim/nvim-lspconfig'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/nvim-cmp'},
  {'L3MON4D3/LuaSnip'},
})
