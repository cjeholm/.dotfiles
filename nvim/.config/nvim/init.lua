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

-- GODOT --
-- paths to check for project.godot file
local paths_to_check = {'/', '/../'}
local is_godot_project = false
local godot_project_path = ''
local cwd = vim.fn.getcwd()

-- iterate over paths and check
for key, value in pairs(paths_to_check) do
    if vim.uv.fs_stat(cwd .. value .. 'project.godot') then
        is_godot_project = true
        godot_project_path = cwd .. value
        break
    end
end

-- check if server is already running in godot project path
local is_server_running = vim.uv.fs_stat(godot_project_path .. '/server.pipe')
-- start server, if not already running
if is_godot_project and not is_server_running then
    vim.fn.serverstart(godot_project_path .. '/server.pipe')
end


-- GODOT LSP
vim.lsp.config('gdscript', {})
vim.lsp.enable('gdscript')


-- LOAD LSP
require("lsp")
-- LOAD FUNCTIONS
require("functions")


-- table.concat(vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({bufnr=0})), ", ")

-- Color override
vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#555577", bg = "NONE", italic = true })

-- Highligt dates nicely in csv files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "csv",
  callback = function()
    vim.api.nvim_set_hl(0, "CsvDate", { link = "Constant" })
    vim.fn.matchadd("CsvDate", [[\v\d{4}-\d{2}-\d{2}]])
  end,
})
