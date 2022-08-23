-- color scheme module, uses gruvbox colors
-- https://github.com/mbadolato/iTerm2-Color-Schemes/blob/master/wezterm/Gruvbox%20Dark.toml
local module = {}

local colors = {
  black        = '#282828',
  white        = '#ebdbb2',
  red          = '#fb4934',
  green        = '#b8bb26',
  blue         = '#83a598',
  yellow       = '#fe8019',
  gray         = '#a89984',
  darkgray     = '#3c3836',
  lightgray    = '#504945',
  inactivegray = '#7c6f64',
}

module.colorscheme = {

  colors = colors,

  tab_bar = {
    background = colors.darkgray,
    inactive_tab_edge = "#575757",
    inactive_tab_edge_hover = colors.darkgray,
    active_tab = {
      bg_color = colors.white,
      fg_color = colors.lightgray,
    },
    inactive_tab = {
      bg_color = colors.darkgray,
      fg_color = colors.white,
    },
    inactive_tab_hover = {
      bg_color = colors.white,
      fg_color = colors.lightgray,
    },
    new_tab = {
      bg_color = colors.white,
      fg_color = colors.lightgray,
    },
    new_tab_hover = {
      bg_color = colors.white,
      fg_color = colors.lightgray,
    },
  },
}

return module
