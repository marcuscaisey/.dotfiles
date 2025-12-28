local wezterm = require('wezterm')

local config = wezterm.config_builder()

local catppuccin_oled = wezterm.color.get_builtin_schemes()['Catppuccin Mocha']
catppuccin_oled.background = '#000000'
catppuccin_oled.tab_bar.background = '#040404'
catppuccin_oled.tab_bar.inactive_tab.bg_color = '#0f0f0f'
catppuccin_oled.tab_bar.new_tab.bg_color = '#080808'
config.color_schemes = {
  ['Catppuccin OLED'] = catppuccin_oled,
}

config.color_scheme = 'Catppuccin OLED'

config.font = wezterm.font('JetBrains Mono')
config.font_size = 14

config.hide_tab_bar_if_only_one_tab = true

config.audible_bell = 'Disabled'

config.quick_select_patterns = {
  -- Please build label
  [[//\w+(?:/\w+)*:[\w#]+]],
}
config.quick_select_remove_styling = true

config.send_composed_key_when_right_alt_is_pressed = false

return config
