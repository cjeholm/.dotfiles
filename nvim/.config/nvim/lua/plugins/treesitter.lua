return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",

  config = function ()
    -- Update with :TSUpdate
    local configs = require("nvim-treesitter.configs")
    configs.setup({
      ensure_installed = { "c", "lua", "vim", "html", "python" },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },  
    })
  end
}
