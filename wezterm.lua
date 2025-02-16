local wezterm = require("wezterm")

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

local act = wezterm.action

local config = {
	font = wezterm.font("Hack Nerd Font Mono", { weight = "Regular" }),
	font_size = 11,

	color_scheme = "Github Dark Dimmed",

	use_fancy_tab_bar = false,
	enable_tab_bar = true,
	show_tab_index_in_tab_bar = true,
	hide_tab_bar_if_only_one_tab = false,
	tab_max_width = 30,
	switch_to_last_active_tab_when_closing_tab = true,

	inactive_pane_hsb = {
		saturation = 0.8,
		brightness = 0.75,
	},

	colors = {
		tab_bar = {
			-- The color of the strip that goes along the top of the window
			-- (does not apply when fancy tab bar is in use)
			background = "#22272e",

			-- The active tab is the one that has focus in the window
			active_tab = {
				-- The color of the background area for the tab
				bg_color = "#363d48",
				-- The color of the text for the tab
				fg_color = "#adbac7",

				-- Specify whether you want "Half", "Normal" or "Bold" intensity for the
				-- label shown for this tab.
				-- The default is "Normal"
				intensity = "Normal",

				-- Specify whether you want "None", "Single" or "Double" underline for
				-- label shown for this tab.
				-- The default is "None"
				underline = "None",

				-- Specify whether you want the text to be italic (true) or not (false)
				-- for this tab.  The default is false.
				italic = false,

				-- Specify whether you want the text to be rendered with strikethrough (true)
				-- or not for this tab.  The default is false.
				strikethrough = false,
			},

			-- Inactive tabs are the tabs that do not have focus
			inactive_tab = {
				bg_color = "#22272e",
				fg_color = "#adbac7",

				-- The same options that were listed under the `active_tab` section above
				-- can also be used for `inactive_tab`.
			},

			-- You can configure some alternate styling when the mouse pointer
			-- moves over inactive tabs
			inactive_tab_hover = {
				bg_color = "#22272e",
				fg_color = "#adbac7",

				-- The same options that were listed under the `active_tab` section above
				-- can also be used for `inactive_tab_hover`.
			},

			-- The new tab button that let you create new tabs
			new_tab = {
				bg_color = "#22272e",
				fg_color = "#adbac7",

				-- The same options that were listed under the `active_tab` section above
				-- can also be used for `new_tab`.
			},

			-- You can configure some alternate styling when the mouse pointer
			-- moves over the new tab button
			new_tab_hover = {
				bg_color = "#22272e",
				fg_color = "#adbac7",

				-- The same options that were listed under the `active_tab` section above
				-- can also be used for `new_tab_hover`.
			},
		},
	},

	window_decorations = "RESIZE",
	macos_window_background_blur = 30,
	--win32_system_backdrop = "Acrylic",
	--win32_arcylic_accent_color = COLOR,

	adjust_window_size_when_changing_font_size = false,
	window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 10,
	},
	initial_rows = 35,
	initial_cols = 125,

	leader = { key = "w", mods = "ALT", timeout_milliseconds = 1000 },
	keys = {
		{
			key = "v",
			mods = "LEADER | SHIFT",
			action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "v",
			mods = "LEADER",
			action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "h",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Left"),
		},
		{
			key = "j",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Down"),
		},
		{
			key = "k",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Up"),
		},
		{
			key = "l",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Right"),
		},
		{
			key = "y",
			mods = "ALT | SHIFT",
			action = act.AdjustPaneSize({ "Left", 5 }),
		},
		{
			key = "u",
			mods = "ALT | SHIFT",
			action = act.AdjustPaneSize({ "Down", 5 }),
		},
		{
			key = "i",
			mods = "ALT | SHIFT",
			action = act.AdjustPaneSize({ "Up", 5 }),
		},
		{
			key = "o",
			mods = "ALT | SHIFT",
			action = act.AdjustPaneSize({ "Right", 5 }),
		},
		{
			key = "q",
			mods = "LEADER",
			action = act.CloseCurrentPane({ confirm = false }),
		},
		{
			key = "N",
			mods = "LEADER | SHIFT",
			action = act.SpawnTab("CurrentPaneDomain"),
		},
		-- Create a new tab in the default domain
		{ key = "n", mods = "LEADER", action = act.SpawnTab("DefaultDomain") },
		-- Create a tab in a named domain
		{
			key = "t",
			mods = "SHIFT|ALT",
			action = act.SpawnTab({
				DomainName = "unix",
			}),
		},
		{
			key = "1",
			mods = "LEADER",
			action = act.ActivateTab(0),
		},
		{
			key = "2",
			mods = "LEADER",
			action = act.ActivateTab(1),
		},
		{
			key = "3",
			mods = "LEADER",
			action = act.ActivateTab(2),
		},
		{
			key = "4",
			mods = "LEADER",
			action = act.ActivateTab(3),
		},
		{
			key = "5",
			mods = "LEADER",
			action = act.ActivateTab(4),
		},
		{
			key = "6",
			mods = "LEADER",
			action = act.ActivateTab(5),
		},
		{
			key = "7",
			mods = "LEADER",
			action = act.ActivateTab(6),
		},
		{
			key = "8",
			mods = "LEADER",
			action = act.ActivateTab(7),
		},
		{
			key = "9",
			mods = "LEADER",
			action = act.ActivateTab(8),
		},
	},
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe" }
	--color, metadata = wezterm.color.load_scheme(".\\colors\\'Github Dark Dimmed.toml'")
	--config.color_scheme = color
	config.window_background_opacity = 0.6
	config.text_background_opacity = 0.6
	config.color_scheme_dirs = { "C:\\Users\\Rain\\.config\\wezterm\\color" }
elseif wezterm.target_triple == "x86_64-unknown-linux-gnu" then
	config.color_scheme_dirs = { "/home/rain/.config/wezterm/color" }
	config.window_background_opacity = 1
	config.text_background_opacity = 1
end

return config
