-- LAZY PLUGINS
return {
  { "rktjmp/lush.nvim"},
  { 'nvim-lua/plenary.nvim'},
  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' }, opts = {} },
  { "nvim-tree/nvim-web-devicons", opts = {} },
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {indent={char="┆"}} },
  { 'lewis6991/gitsigns.nvim', opts = {} },
  { 'folke/neodev.nvim', opts = {} },

}
