return {
	"cjeholm/findbacklinks",
	config = function()
		require("findbacklinks")
	end,
	lazy = false,
	vim.keymap.set("n", "gb", "<cmd>FindBacklinks<cr>", { desc = "Find Backlinks" }),
}
