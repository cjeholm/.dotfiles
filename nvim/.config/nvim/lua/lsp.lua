-- =====================================================================
--  Native LSP setup for Neovim 0.11+
--  No dependency on nvim-lspconfig
-- =====================================================================

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- ---------------------------------------------------------------------
-- Helper: start LSP when filetype matches
-- ---------------------------------------------------------------------
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

-- ---------------------------------------------------------------------
-- Language servers
-- ---------------------------------------------------------------------

setup_lsp("nixd", {
	cmd = { "nixd" },
	filetypes = { "nix" },
	root_dir = function(fname)
		return vim.fs.dirname(vim.fs.find({ ".git", "flake.nix", "default.nix" }, { upward = true, path = fname })[1])
	end,
	settings = {
		nixd = {
			nixpkgs = { expr = "import <nixpkgs> { }" },
			formatting = { command = { "alejandra" } },
		},
	},
})

setup_lsp("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_dir = function(fname)
		return vim.fs.dirname(vim.fs.find({ ".git", ".luarc.json", "init.lua" }, { upward = true, path = fname })[1])
	end,
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			workspace = { checkThirdParty = false },
		},
	},
})

setup_lsp("pylsp", {
	cmd = { "pylsp" },
	filetypes = { "python" },
	root_dir = function(fname)
		return vim.fs.dirname(vim.fs.find({ ".git", "pyproject.toml", "setup.py" }, { upward = true, path = fname })[1])
	end,
})

setup_lsp("rust_analyzer", {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_dir = function(fname)
		return vim.fs.dirname(
			vim.fs.find({ "Cargo.toml", "rust-project.json", ".git" }, { upward = true, path = fname })[1]
		)
	end,
	settings = {
		["rust-analyzer"] = {
			cargo = { allFeatures = true },
			check = { command = "check" },
		},
	},
})
-- ---------------------------------------------------------------------
-- Diagnostics & keymaps
-- ---------------------------------------------------------------------

vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspKeymaps", {}),
	callback = function(ev)
		local b = { buffer = ev.buf }
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Go to definition of symbol under cursor
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = b.buffer, desc = "Go to definition" })

		-- Go to declaration of symbol under cursor
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = b.buffer, desc = "Go to declaration" })

		-- List all implementations of the symbol under cursor
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = b.buffer, desc = "List implementations" })

		-- Show signature help in a floating window
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = b.buffer, desc = "Show signature help" })

		-- Add current folder to workspace
		vim.keymap.set(
			"n",
			"<space>wa",
			vim.lsp.buf.add_workspace_folder,
			{ buffer = b.buffer, desc = "Add workspace folder" }
		)

		-- Remove current folder from workspace
		vim.keymap.set(
			"n",
			"<space>wr",
			vim.lsp.buf.remove_workspace_folder,
			{ buffer = b.buffer, desc = "Remove workspace folder" }
		)

		-- List workspace folders
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, { buffer = b.buffer, desc = "List workspace folders" })

		-- Go to type definition
		vim.keymap.set(
			"n",
			"<space>D",
			vim.lsp.buf.type_definition,
			{ buffer = b.buffer, desc = "Go to type definition" }
		)

		-- Rename symbol (updates all references)
		vim.keymap.set("n", "<space>r", vim.lsp.buf.rename, { buffer = b.buffer, desc = "Rename symbol" })

		-- Code actions (quick fixes, refactors)
		vim.keymap.set({ "n", "v" }, "<space>a", vim.lsp.buf.code_action, { buffer = b.buffer, desc = "Code action" })

		-- List references of the symbol under cursor
		vim.keymap.set("n", "gl", vim.lsp.buf.references, { buffer = b.buffer, desc = "List references" })

		-- Hover documentation (optional, uncomment if you like)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = b.buffer, desc = "Hover documentation" })

		-- Format buffer (optional, uncomment if you enable format-on-save)
		-- vim.keymap.set("n", "<space>f", function() vim.lsp.buf.format({ async = true }) end,
		--   { buffer = b.buffer, desc = "Format buffer" })
	end,
})

--  -----------------------
--  Check on Save
--  -----------------------
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(args)
		local clients = vim.lsp.get_clients({ bufnr = args.buf })
		for _, client in ipairs(clients) do
			if client.supports_method("textDocument/formatting") then
				vim.lsp.buf.format({ bufnr = args.buf, async = false })
				return
			end
		end
	end,
})
