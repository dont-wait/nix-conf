return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
	},
	{
		"ellisonleao/gruvbox.nvim",
		name = "gruvbox",
		priority = 1000,
		lazy = false,
	},
	{
		"alligator/accent.vim",
		name = "accent",
		lazy = false,
		priority = 1000,
		-- Đưa toàn bộ cấu hình vào plugin cuối cùng này
		config = function()
			local themes = {
				"tokyonight",
				"accent",
				"gruvbox",
				"catppuccin",
				"rose-pine",
			}

			local theme_file = vim.fn.stdpath("data") .. "/last_theme.txt"
			local function save_theme(theme)
				local f = io.open(theme_file, "w")
				if f then
					f:write(theme)
					f:close()
				end
			end

			local function load_theme()
				local f = io.open(theme_file, "r")
				if f then
					local theme = f:read("*l")
					f:close()
					return theme
				end
				return nil
			end

			-- Tìm index của theme mặc định (ví dụ là tokyonight)
			local current_theme_index = 1
			local saved = load_theme()
			if saved then
				for i, t in ipairs(themes) do
					if t == saved then
						current_theme_index = i
						break
					end
				end
			end

			-- Thiết lập theme mặc định ngay khi mở máy
			-- Dùng pcall để không bị crash nếu có lỗi tải plugin
			pcall(vim.cmd.colorscheme, themes[current_theme_index])

			-- Key mapping để switch theme
			vim.keymap.set("n", "<leader>nt", function()
				current_theme_index = current_theme_index + 1
				if current_theme_index > #themes then
					current_theme_index = 1
				end

				local theme = themes[current_theme_index]
				local success, _ = pcall(vim.cmd.colorscheme, theme)

				if success then
                    save_theme(theme)
					print("🎨 Theme: " .. theme)
				else
					print("❌ Lỗi: Không tìm thấy " .. theme)
				end
			end, { noremap = true, silent = true, desc = "Switch Theme" })
		end,
	},
}
