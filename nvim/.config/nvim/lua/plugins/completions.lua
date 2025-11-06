return {
  {
    "hrsh7th/cmp-nvim-lsp",
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp_ok, cmp = pcall(require, "cmp")
      if not cmp_ok then
        return
      end

      local luasnip_ok, luasnip = pcall(require, "luasnip")
      if luasnip_ok then
        require("luasnip.loaders.from_vscode").lazy_load()
      end

      local cmp_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = cmp_lsp_ok and cmp_nvim_lsp.default_capabilities() or {}

      cmp.setup({
        snippet = {
          expand = function(args)
            if luasnip_ok then
              luasnip.lsp_expand(args.body)
            end
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "path" },
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- Markdown completions via LSP (Marksman)
      cmp.setup.filetype("markdown", {
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, -- Marksman LSP
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
      -- Helper to trigger [[wikilink]] completion in Markdown
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.keymap.set("i", "<C-l>", function()
            local cursor = vim.api.nvim_win_get_cursor(0)
            local row, col = cursor[1], cursor[2]
            local line = vim.api.nvim_get_current_line()
            local before = line:sub(1, col)
            if not before:match("%[%[$") then
              vim.api.nvim_put({ "[[" }, "c", true, true)
            end
            require("cmp").complete()
          end, { buffer = 0, desc = "Insert [[ and complete wikilink" })
        end,
      })
    end,
  },
}
