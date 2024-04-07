return {
  "neovim/nvim-lspconfig",

  config = function()
    local lspconfig = require("lspconfig")
--    lspconfig.lua-lsp.setup({})
    lspconfig.pylsp.setup({})
  end
}
