return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local lspconfig = require("lspconfig")
      --      lspconfig.tsserver.setup({
      --        capabilities = capabilities
      --      })
      --      lspconfig.solargraph.setup({
      --        capabilities = capabilities
      --      })
      lspconfig.pylsp.setup({
        capabilities = capabilities
      })
      lspconfig.html.setup({
        capabilities = capabilities
      })
      lspconfig.lua_ls.setup({
        capabilities = capabilities
      })
      lspconfig.clangd.setup({
        capabilities = capabilities
      })

      -- Global mappings.
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { desc = "Open Diagnostics" })
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { desc = "Add buf diag to loc list" })

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = "Go to declaration" })
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
          --    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = "List implementations" })
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = "View signature info" })
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, { desc = "Del workspace folder" })
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, { desc = "List workspace folders" })
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, { desc = "Go to type definition" })
          vim.keymap.set('n', '<space>r', vim.lsp.buf.rename, { desc = "Rename symbol (all refs)" })
          vim.keymap.set({'n', 'v' }, '<space>a', vim.lsp.buf.code_action, { desc = "Code action" })
          vim.keymap.set('n', 'gl', vim.lsp.buf.references, { desc = "List references" })
          vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
          end, { desc = "Format" })
        end,
      })
    end,
  },
}
