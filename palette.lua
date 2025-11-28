local wezterm = require("wezterm")
local palette = {}

palette.creat_tab_bar_color = function (colors)
    local background = colors.background
    local foreground = colors.foreground
    local tab_bar = {
        background = background,
        active_tab = {
            -- The color of the background area for the tab
            bg_color = colors.ansi[4],
            -- The color of the text for the tab
            fg_color = "#ffffff",
            intensity = "Normal",
            underline = "None",
            italic = false,
            strikethrough = false,
        },
        inactive_tab = {
            bg_color = background,
            fg_color = foreground,
        },
        inactive_tab_hover = {
            bg_color = background,
            fg_color = foreground,
        },
        new_tab = {
            bg_color = background,
            fg_color = foreground,
        },
        new_tab_hover = {
            bg_color = background,
            fg_color = foreground,
        },
    }

    return tab_bar
end

palette.load_colorscheme = function (config, colorscheme)
    local colors, matadata = wezterm.color.load_scheme(colorscheme)
    colors.tab_bar = palette.creat_tab_bar_color(colors)
    config.colors = colors
    config.command_palette_bg_color = colors.foreground
    config.command_palette_fg_color = colors.background
    return config
end

return palette
