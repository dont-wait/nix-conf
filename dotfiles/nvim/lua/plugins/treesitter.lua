return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			ensure_installed = {
				"c",
				"lua",
				"vim",
				"javascript",
				"typescript",
				"tsx",
				"jsx",
				"html",
				"css",
				"go",
				"gomod",
				"gowork",
				"gosum",
				"java",
				"json",
				"jsonc",
				"zig",
				"c_sharp",
				"dart",
				"hurl",
				"bash",
				"http",
				"yaml",
				"toml",
				"python",
				"nix",
			},
			sync_install = false,
			auto_install = false,
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
			},
		})
	end,
}
