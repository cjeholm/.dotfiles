-- MINIMAL NEOVIM IDE CONFIG
-- Inspired by typecrafts video series
-- https://www.youtube.com/watch?v=zHTeCSVAFNY
--
-- By Conny Holm 2024
--


-- SET INDENTATION
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "


-- PACKAGE MANAGER
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- LAZY PLUGINS
local plugins = {
  { "rktjmp/lush.nvim" },

  { "briones-gabriel/darcula-solid.nvim",
    name = "darcula-solid",
    priority = 1000
  },

  { 'nvim-lua/plenary.nvim' },

  { 'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  { "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate"
  },

  { "nvim-tree/nvim-web-devicons" },

  { "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    }
  },

}


-- LAZY OPTIONS
local opts = {}


-- LOAD LAZY
-- Update with :Lazy
require("lazy").setup(plugins, opts)


-- SETUP TELESCOPE
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})


-- SETUP TREESITTER
-- Update with :TSUpdate
local configs = require("nvim-treesitter.configs")
configs.setup({
  ensure_installed = { "c", "lua", "vim", "html", "python" },
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true },  
})


-- SETUP NEOTREE
vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>')


-- SET COLOR SCHEME
vim.cmd('colorscheme darcula-solid')
vim.cmd 'set termguicolors'


-- LINE NUMBERS
vim.wo.number = true          -- Default on
vim.wo.relativenumber = true
