-- =========================================================
--  Native LSP Setup for Neovim 0.11+
--  All your servers included
-- =========================================================

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Helper to start LSP for given filetypes
local function setup_lsp(name, opts)
  opts = opts or {}
  local pattern = opts.filetypes or {}
  if type(pattern) == "string" then
    pattern = { pattern }
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = pattern,
    callback = function(ctx)
      local client_opts = vim.tbl_deep_extend("force", opts, {
        capabilities = capabilities,
        bufnr = ctx.buf,
      })
      vim.lsp.start(client_opts)
    end,
  })
end

-- ===================== Servers ==========================

-- Python
setup_lsp("pylsp", {
  cmd = { "pylsp" },
  filetypes = { "python" },
  root_dir = function(fname)
    local root = vim.fs.find({ ".git", "pyproject.toml", "setup.py" }, { upward = true, path = fname })[1]
    return root and vim.fs.dirname(root) or vim.loop.cwd()
  end,
})

-- HTML
setup_lsp("html", {
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = { "html" },
  root_dir = function(fname)
    local root = vim.fs.find({ ".git", "index.html" }, { upward = true, path = fname })[1]
    return root and vim.fs.dirname(root) or vim.loop.cwd()
  end,
})

-- Lua
setup_lsp("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_dir = function(fname)
    local root = vim.fs.find({ ".git", ".luarc.json", "init.lua" }, { upward = true, path = fname })[1]
    return root and vim.fs.dirname(root) or vim.loop.cwd()
  end,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
})

-- C/C++
setup_lsp("clangd", {
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_dir = function(fname)
    local root = vim.fs.find({ ".git", "compile_commands.json" }, { upward = true, path = fname })[1]
    return root and vim.fs.dirname(root) or vim.loop.cwd()
  end,
})

-- Rust
setup_lsp("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_dir = function(fname)
    local root = vim.fs.find({ "Cargo.toml", "rust-project.json", ".git" }, { upward = true, path = fname })[1]
    return root and vim.fs.dirname(root) or vim.loop.cwd()
  end,
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      check = { command = "check" },
    },
  },
})

-- Nix
setup_lsp("nixd", {
  cmd = { "nixd" },
  filetypes = { "nix" },
  root_dir = function(fname)
    local root = vim.fs.find({ ".git", "flake.nix", "default.nix" }, { upward = true, path = fname })[1]
    return root and vim.fs.dirname(root) or vim.loop.cwd()
  end,
  settings = {
    nixd = {
      nixpkgs = { expr = "import <nixpkgs> { }" },
      formatting = { command = { "alejandra" } },
    },
  },
})

-- Marksman LSP
-- Start Marksman manually using Neovim's built-in LSP client
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local root = vim.fs.root(bufname, { ".marksman.toml", ".git" }) or vim.fn.getcwd()

    vim.lsp.start({
      name = "marksman",
      cmd = { "marksman", "server" },
      root_dir = root,
      capabilities = (function()
        local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        return ok and cmp_nvim_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()
      end)(),
      filetypes = { "markdown" },
    })
  end,
})

-- ===================== Diagnostics & Keymaps ==========================
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "Open diagnostics" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "Add buf diag to loc list" })

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspKeymaps", {}),
  callback = function(ev)
    local b = { buffer = ev.buf }
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- LSP keymaps with descriptions
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = b.buffer, desc = "Go to definition" })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = b.buffer, desc = "Go to declaration" })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = b.buffer, desc = "List implementations" })
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = b.buffer, desc = "Show signature help" })
    vim.keymap.set(
      "n",
      "<space>wa",
      vim.lsp.buf.add_workspace_folder,
      { buffer = b.buffer, desc = "Add workspace folder" }
    )
    vim.keymap.set(
      "n",
      "<space>wr",
      vim.lsp.buf.remove_workspace_folder,
      { buffer = b.buffer, desc = "Remove workspace folder" }
    )
    vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, { buffer = b.buffer, desc = "List workspace folders" })
    vim.keymap.set(
      "n",
      "<space>D",
      vim.lsp.buf.type_definition,
      { buffer = b.buffer, desc = "Go to type definition" }
    )
    vim.keymap.set("n", "<space>r", vim.lsp.buf.rename, { buffer = b.buffer, desc = "Rename symbol" })
    vim.keymap.set({ "n", "v" }, "<space>a", vim.lsp.buf.code_action, { buffer = b.buffer, desc = "Code action" })
    vim.keymap.set("n", "gl", vim.lsp.buf.references, { buffer = b.buffer, desc = "List references" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = b.buffer, desc = "Hover documentation" })
  end,
})
-- Auto‑start Marksman LSP for Markdown (using up‑to‑date API)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local marksman_running = false

    for _, client in pairs(vim.lsp.get_clients()) do
      if client.name == "marksman" then
        -- Check if the client is attached to the current buffer
        if client.attached_buffers and vim.tbl_contains(client.attached_buffers, buf) then
          marksman_running = true
          break
        end
      end
    end

    if not marksman_running then
      vim.lsp.start({
        name = "marksman",
        cmd = { "marksman", "server" },
        filetypes = { "markdown" },
        root_dir = function(fname)
          local root = vim.fs.find({ ".marksman.json", ".git" }, { upward = true, path = fname })[1]
          return root and vim.fs.dirname(root) or vim.fs.dirname(fname)
        end,
      })
    end
  end,
})
