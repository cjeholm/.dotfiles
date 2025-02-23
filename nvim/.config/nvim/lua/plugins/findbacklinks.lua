return {
	"cjeholm/findbacklinks",
  -- dev = true, -- enable dev mode
  -- dir ="~/Documents/lua/findbacklinks", -- use local path
	config = function()
		require("findbacklinks")
	end,
	lazy = false,
	vim.keymap.set("n", "gb", "<cmd>FindBacklinks<cr>", { desc = "Find Backlinks" }),
	vim.keymap.set("n", "go", "<cmd>FindOutlinks<cr>", { desc = "Find Outgoing links" }),
}
