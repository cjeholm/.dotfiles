-- MINIMAL NEOVIM IDE CONFIG
-- Inspired by typecrafts video series
-- https://www.youtube.com/watch?v=zHTeCSVAFNY
--
-- By Conny Holm 2024
--


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


-- LOAD OPTIONS
require("vim-options")


-- LOAD LAZY
-- Update with :Lazy
-- Plugins are listed in lua/plugins.lua
-- and in dir lua/plugins/
require("lazy").setup("plugins")
