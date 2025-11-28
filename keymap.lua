local wezterm = require("wezterm")
local palette = require("palette")
local act = wezterm.action

local colorscheme_selector = function (window, pane)
    local choices = {}

    for _, path in ipairs(wezterm.read_dir(wezterm.config_dir .. '/color')) do
        local colorscheme = string.match(path, "([%w%s-]+).toml")
        table.insert(choices, { label = colorscheme, id = path })
    end

    window:perform_action(
        act.InputSelector {
            action = wezterm.action_callback(function(window, pane, id, label)
                if id and label then
                    local config = window:get_config_overrides() or {}
                    config = palette.load_colorscheme(config, id)
                    window:set_config_overrides(config)
                end
            end),
            title = 'ColorScheme',
            choices = choices,
            description = 'choose a colorscheme or press / to search.',
        },
        pane
    )
end

local keys = {
    { key = 'c', mods = 'LEADER',         action = wezterm.action_callback(colorscheme_selector),},
    { key = "v", mods = "LEADER | SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }), },
    { key = "v", mods = "LEADER",         action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),},
    { key = "h", mods = "LEADER",         action = act.ActivatePaneDirection("Left"),},
    { key = "j", mods = "LEADER",         action = act.ActivatePaneDirection("Down"),},
    { key = "k", mods = "LEADER",         action = act.ActivatePaneDirection("Up"),},
    { key = "l", mods = "LEADER",         action = act.ActivatePaneDirection("Right"),},
    { key = "y", mods = "ALT | SHIFT",    action = act.AdjustPaneSize({ "Left", 5 }),},
    { key = "u", mods = "ALT | SHIFT",    action = act.AdjustPaneSize({ "Down", 5 }),},
    { key = "i", mods = "ALT | SHIFT",    action = act.AdjustPaneSize({ "Up", 5 }),},
    { key = "o", mods = "ALT | SHIFT",    action = act.AdjustPaneSize({ "Right", 5 }),},
    { key = "q", mods = "LEADER",         action = act.CloseCurrentPane({ confirm = false }),},
    { key = "m", mods = "LEADER",         action = act.ShowLauncher,},
    { key = "N", mods = "LEADER | SHIFT", action = act.SpawnTab("CurrentPaneDomain"),},
    { key = "n", mods = "LEADER",         action = act.SpawnTab("DefaultDomain") },
    { key = "t", mods = "LEADER",         action = act.SpawnTab({ DomainName = "unix", }), },
    { key = "=", mods = "LEADER",         action = act.IncreaseFontSize },
    { key = "-", mods = "LEADER",         action = act.DecreaseFontSize },
    { key = "r", mods = "LEADER",         action = act.ResetFontAndWindowSize },
    { key = "1", mods = "LEADER",         action = act.ActivateTab(0), },
    { key = "2", mods = "LEADER",         action = act.ActivateTab(1), },
    { key = "3", mods = "LEADER",         action = act.ActivateTab(2), },
    { key = "4", mods = "LEADER",         action = act.ActivateTab(3), },
    { key = "5", mods = "LEADER",         action = act.ActivateTab(4), },
    { key = "6", mods = "LEADER",         action = act.ActivateTab(5), },
    { key = "7", mods = "LEADER",         action = act.ActivateTab(6), },
    { key = "8", mods = "LEADER",         action = act.ActivateTab(7), },
    { key = "9", mods = "LEADER",         action = act.ActivateTab(8), }
}

return keys
