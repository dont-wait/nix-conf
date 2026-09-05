local wezterm = require("wezterm")
wezterm.log_info("config loaded successfully")
local config = wezterm.config_builder()
local brightness = 0.05

-- image setting
local home = os.getenv("HOME")
local background_folder = home .. "/Documents/git/nix-conf/dotfiles/bg"

local function pick_random_background(folder)
	local images = wezterm.glob(folder .. "/*")
	if #images > 0 then
		return images[math.random(#images)]
	end
end

local bg_image = background_folder .. "/1387138.png"

local function make_background(image, bright)
	return {
		{
			source = { File = image },
			hsb = {
				brightness = bright,
				hue = 1.0,
				saturation = 0.8,
			},
			opacity = 1.0,
			horizontal_align = "Center",
			vertical_align = "Middle",
			width = "Cover",
			height = "Cover",
		},
	}
end
config.background = make_background(bg_image, brightness)
-- end image setting

-- window setting
config.window_background_opacity = 1
config.macos_window_background_blur = 85
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.color_scheme = "Tokyo Night"
config.font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Regular", stretch = "Normal", style = "Normal" })
config.font_size = 19
config.adjust_window_size_when_changing_font_size = false
config.window_decorations = "RESIZE"
config.enable_tab_bar = false
config.status_update_interval = 0
config.window_frame = {
	-- border_left_width = "0.28cell",
	-- border_right_width = "0.28cell",
	-- border_bottom_height = "0.15cell",
	-- border_top_height = "0.15cell",
	-- border_left_color = "pink",
	-- border_right_color = "pink",
	-- border_bottom_color = "pink",
	-- border_top_color = "pink",
}

-- keys
config.keys = {
	{
		key = "b",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(window)
			local new_bg_image = pick_random_background(background_folder)
			if new_bg_image then
				bg_image = new_bg_image
				window:set_config_overrides({
					background = make_background(bg_image, brightness),
				})
				wezterm.log_info("New bg:" .. bg_image)
			else
				wezterm.log_error("Could not find bg image")
			end
		end),
	},
	{
		key = "L",
		mods = "CTRL|SHIFT",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
	{
		key = ">",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(window)
			brightness = math.min(brightness + 0.01, 1.0)
			window:set_config_overrides({
				background = make_background(bg_image, brightness),
			})
		end),
	},
	{
		key = "<",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(window)
			brightness = math.max(brightness - 0.01, 0.01)
			window:set_config_overrides({
				background = make_background(bg_image, brightness),
			})
		end),
	},
}

-- others
config.default_cursor_style = "BlinkingUnderline"
config.cursor_thickness = 2
return config
