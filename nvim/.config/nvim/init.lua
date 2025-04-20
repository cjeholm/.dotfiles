-- MINIMAL NEOVIM IDE CONFIG
-- Inspired by typecrafts video series
-- https://www.youtube.com/watch?v=zHTeCSVAFNY
--
-- By Conny Holm 2024
--
-- Made for NixOs. Install LSP, linter and other
-- binary packages with nix. Mason will not work
-- on NixOs and is excluded from this configuration.


-- PACKAGE MANAGER
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

-- Color override
vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#8888aa", bg = "NONE", italic = true })
