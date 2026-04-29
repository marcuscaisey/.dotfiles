local wezterm = require('wezterm')

local config = wezterm.config_builder()

config.color_scheme = 'Catppuccin Mocha'

config.hide_tab_bar_if_only_one_tab = true

config.audible_bell = 'Disabled'

config.quick_select_patterns = {
  -- Please build label
  [[//\w+(?:/\w+)*:[\w#]+]],
}
config.quick_select_remove_styling = true

config.send_composed_key_when_right_alt_is_pressed = false

return config
