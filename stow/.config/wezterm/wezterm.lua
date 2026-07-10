local wezterm = require('wezterm')

local config = wezterm.config_builder()

config.color_scheme = 'Catppuccin Mocha'

config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

config.hide_tab_bar_if_only_one_tab = true

config.audible_bell = 'Disabled'

config.quick_select_patterns = {
    -- Please build label
    [[//(?:\w+(?:/\w+)*)?:[\w\-#]+]],
    -- Github issue number
    [[#\d+]],
}
config.quick_select_remove_styling = true

config.send_composed_key_when_right_alt_is_pressed = false

return config
