local wezterm = require("wezterm")

wezterm.on('update-right-status', function(window, pane)
    local date = wezterm.strftime '%a %b %-d %H:%M '
    window:set_right_status(wezterm.format {
        { Text = wezterm.nerdfonts.fa_clock_o .. ' ' .. date },
    })
end)

wezterm.on(
    'format-tab-title',
    function(tab, tabs, panes, config, hover, max_width)
        local function tab_title(tab_info)
            local title = tab_info.tab_title
            if title and #title > 0 then
                return title
            end
            return tab_info.active_pane.title
        end

        local LEFT_HALF_CIRCLE = wezterm.nerdfonts.ple_left_half_circle_thick
        local RIGHT_HALF_CIRCLE = wezterm.nerdfonts.ple_right_half_circle_thick

        local edge_background = config.colors.background
        local background = config.colors.background
        local foreground = config.colors.foreground

        if tab.is_active then
            -- local index = math.random(2, #config.colors.ansi)
            background = config.colors.ansi[5]
            foreground = "#ffffff"
        elseif hover then
            background = config.colors.background
            foreground = config.colors.foreground
        end

        local edge_foreground = background
        local title = tab_title(tab)
        title = tab.tab_index + 1 .. " " .. wezterm.truncate_right(title, max_width - 5)

        return {
            { Background = { Color = edge_background } },
            { Foreground = { Color = edge_foreground } },
            { Text = ' ' },
            { Background = { Color = edge_background } },
            { Foreground = { Color = edge_foreground } },
            { Text = LEFT_HALF_CIRCLE },
            { Background = { Color = background } },
            { Foreground = { Color = foreground } },
            { Text = title },
            { Background = { Color = edge_background } },
            { Foreground = { Color = edge_foreground } },
            { Text = RIGHT_HALF_CIRCLE },
        }
    end
)
