local wezterm = require("wezterm")
local ssh = require("ssh")


wezterm.on('update-right-status', function(window, pane)
    -- "Wed Mar 3 08:14"
    local date = wezterm.strftime '%a %b %-d %H:%M '

    window:set_right_status(wezterm.format {
        { Text = wezterm.nerdfonts.fa_clock_o .. ' ' .. date },
    })
end)


local act = wezterm.action

local function creat_tab_bar_color(colors)
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

local colors = wezterm.color.load_scheme(wezterm.config_dir .. "/color/Github Dark Dimmed.toml")
colors.tab_bar = creat_tab_bar_color(colors)

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_left_half_circle_thick
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_right_half_circle_thick

function tab_title(tab_info)
    local title = tab_info.tab_title
    if title and #title > 0 then
        return title
    end
    return tab_info.active_pane.title
end

wezterm.on(
    'format-tab-title',
    function(tab, tabs, panes, config, hover, max_width)
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

        -- ensure that the titles fit in the available space,
        -- and that we have room for the edges.
        title = tab.tab_index + 1 .. " " .. wezterm.truncate_right(title, max_width - 5)

        return {
            { Background = { Color = edge_background } },
            { Foreground = { Color = edge_foreground } },
            { Text = ' ' },
            { Background = { Color = edge_background } },
            { Foreground = { Color = edge_foreground } },
            { Text = SOLID_LEFT_ARROW },
            { Background = { Color = background } },
            { Foreground = { Color = foreground } },
            { Text = title },
            { Background = { Color = edge_background } },
            { Foreground = { Color = edge_foreground } },
            { Text = SOLID_RIGHT_ARROW },
        }
    end
)


local config = {
    audible_bell = "Disabled",
    -- window_decorations = "INTEGRATED_BUTTONS|RESIZE",
    font = wezterm.font_with_fallback {
        { family = "Hack Nerd Font Mono",  weight = "Regular" },
        { family = "LXGW WenKai Mono",     weight = "Regular" },
    },
    font_size = 10,

    use_fancy_tab_bar = false,
    enable_tab_bar = true,
    show_tab_index_in_tab_bar = true,
    hide_tab_bar_if_only_one_tab = false,
    tab_max_width = 30,
    switch_to_last_active_tab_when_closing_tab = true,

    colors = colors,

    command_palette_bg_color = colors.foreground,
    command_palette_fg_color = colors.background,
    -- command_palette_font = wezterm.font "Hack Nerd Font Mono",
    command_palette_font_size = 12.0,
    command_palette_rows = 14,

    window_decorations = "RESIZE",
    -- win32_system_backdrop = "Acrylic",
    -- win32_arcylic_accent_color = COLOR,

    adjust_window_size_when_changing_font_size = false,
    window_padding = {
        left = 10,
        right = 10,
        top = 10,
        bottom = 10,
    },
    initial_rows = 35,
    initial_cols = 125,
    window_background_opacity = 1,
    text_background_opacity = 1,

    leader = { key = "w", mods = "ALT", timeout_milliseconds = 1000 },
    keys = {
        {
            key = 'c',
            mods = 'LEADER',
            action = wezterm.action_callback(function(window, pane)
                local choices = {}
                for _, path in ipairs(wezterm.read_dir(wezterm.config_dir .. '/color')) do
                    local colorscheme = string.match(path, "([%w%s-]+).toml")
                    table.insert(choices, { label = colorscheme, id = path })
                end

                window:perform_action(
                    act.InputSelector {
                        action = wezterm.action_callback(function(window, pane, id, label)
                            if not id and not label then
                                wezterm.log_info 'cancelled'
                            else
                                wezterm.log_info('you selected ', id, label)
                                -- Since we didn't set an id in this example, we're
                                -- sending the label
                                local colors, matadata = wezterm.color.load_scheme(id)
                                colors.tab_bar = creat_tab_bar_color(colors)
                                local overrides = window:get_config_overrides() or {}
                                overrides.colors = colors
                                window:set_config_overrides(overrides)
                            end
                        end),
                        title = 'ColorScheme',
                        choices = choices,
                        description = 'choose a colorscheme or press / to search.',
                    },
                    pane
                )
            end),
        },
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
            key = "m",
            mods = "LEADER",
            action = act.ShowLauncher,
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
            key = "=",
            mods = "LEADER",
            action = act.IncreaseFontSize
        },
        {
            key = "-",
            mods = "LEADER",
            action = act.DecreaseFontSize
        },
        {
            key = "r",
            mods = "LEADER",
            action = act.ResetFontAndWindowSize
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

    launch_menu = {},
    ssh_domains = {},
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.default_prog = { "wsl.exe", "~" }
    config.font_size = 10

    table.insert(config.launch_menu, {
        label = "Powershell",
        args = { "powershell.exe" },
    })
    table.insert(config.launch_menu, {
        label = "WSL",
        args = { "wsl.exe", "~"},
    })
    table.insert(config.launch_menu, {
        label = "Msys2 Ucrt64",
        args = { "D:\\bin\\msys64\\msys2_shell.cmd", "-defterm", "-no-start", "-ucrt64" },
    })
elseif wezterm.target_triple == "x86_64-unknown-linux-gnu" then
    config.font_size = 12
end

-- create ssh.lua, add content like this
-- return {
--     {
-- 	    name = "remote server",
--         host = "127.0.0.1",
--         username = "root",
--         password = "123456",
--     }
-- }

for _, ssh_info in ipairs(ssh) do
    table.insert(config.ssh_domains, {
        name = "SSH-" .. ssh_info.name,
        remote_address = ssh_info.host,
        username = ssh_info.username,
    })
end

return config
