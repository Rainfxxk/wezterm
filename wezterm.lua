local wezterm = require("wezterm")
local palette = require("palette")
require("appearance")

-- local colors = palette.load_colorscheme(wezterm.config_dir .. "/color/Github Dark Dimmed.toml")

local config = {
    audible_bell = "Disabled",
    -- window_decorations = "INTEGRATED_BUTTONS|RESIZE",
    font = wezterm.font_with_fallback {
        { family = "Hack Nerd Font Mono",  weight = "Regular" },
        { family = "LXGW WenKai Mono",     weight = "Regular" },
    },
    font_size = 9,

    use_fancy_tab_bar = false,
    enable_tab_bar = true,
    show_tab_index_in_tab_bar = true,
    hide_tab_bar_if_only_one_tab = false,
    tab_max_width = 30,
    switch_to_last_active_tab_when_closing_tab = true,

    command_palette_font_size = 12.0,
    command_palette_rows = 14,

    window_decorations = "RESIZE",

    initial_rows = 45,
    initial_cols = 180,

    adjust_window_size_when_changing_font_size = false,
    window_padding = { left = 5, right = 5, top = 5, bottom = 5 },
    window_background_opacity = 1,
    text_background_opacity = 1,

    leader = { key = "w", mods = "ALT", timeout_milliseconds = 1000 },
    keys = require("keymap"),

    launch_menu = {},
    ssh_domains = require("ssh"),
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.default_prog = { "wsl.exe", "~" }
    config.launch_menu = {
        { label = "Powershell", args = { "powershell.exe" }, },
        { label = "WSL", args = { "wsl.exe", "~"}, },
        { label = "Msys2 Ucrt64", args = { "D:\\bin\\msys64\\msys2_shell.cmd", "-defterm", "-no-start", "-ucrt64" }, }
    }
end

palette.load_colorscheme(config, wezterm.config_dir .. "/color/Catppuccin Frappe.toml")

return config
