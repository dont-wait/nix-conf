return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")
			local themes = require("telescope.themes")

			telescope.setup({
				defaults = {
					file_ignore_patterns = { ".class" },
					layout_config = {
						horizontal = {
							preview_width = 0.6,
							width = 0.9,
						},
						vertical = {
							preview_height = 0.6,
							height = 0.85,
						},
					},
				},
				pickers = {
					find_files = {
						hidden = true,
					},
					live_grep = {
						additional_args = function()
							return { "--hidden", "--glob", "!.git/*" }
						end,
					},
				},
				extensions = {
					["ui-select"] = themes.get_dropdown({}),
				},
			})

			telescope.load_extension("ui-select")

			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
			vim.keymap.set("n", "<leader>pf", builtin.git_files, { desc = "Find Git Files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
			vim.keymap.set("n", "<leader>fG", function()
				builtin.live_grep({
					additional_args = function()
						return { "--hidden", "--glob", "!.git/*" }
					end,
				})
			end, { desc = "Live Grep includes hidden files" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
			vim.keymap.set("n", "<leader>fs", function()
				builtin.grep_string({ search = vim.fn.input("Grep For > ") })
			end, { desc = "Telescope grep with input" })
		end,
	},
}
