return {
	"opdavies/toggle-checkbox.nvim",
	event = "LspAttach",
	-- opts = {}, -- required, even if empty
	-- vim.keymap.set("n", "<leader>tt", ":lua require('toggle-checkbox').toggle()<CR>")
	keys = {
		{
			"<leader>tt",
			function()
				require("toggle-checkbox").toggle()
			end,
			desc = "Toggle checkbox",
		},
	},
}
