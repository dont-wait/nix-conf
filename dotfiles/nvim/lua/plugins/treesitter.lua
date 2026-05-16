return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			install_dir = vim.fn.stdpath("data") .. "/treesitter",
		})

		-- Cài parsers
		require("nvim-treesitter").install({
			"c",
			"lua",
			"vim",
			"javascript",
			"typescript",
			"tsx",
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
		})

		-- Bật highlight và indent cho tất cả filetype
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				local ok = pcall(vim.treesitter.start)
				if ok then
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})

		-- Fix filetype detection cho hurl
		vim.filetype.add({
			extension = { hurl = "hurl" },
		})
	end,
}
