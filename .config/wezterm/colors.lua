-- color scheme module, uses gruvbox colors
-- https://github.com/mbadolato/iTerm2-Color-Schemes/blob/master/wezterm/Gruvbox%20Dark.toml
local module = {}

local gruvbox_colors = {
  black = '#282828',
  white = '#ebdbb2',
  red = '#fb4934',
  green = '#b8bb26',
  blue = '#83a598',
  orange = '#fe8019',
  yellow = '#fabd2f',
  gray = '#a89984',
  darkgray = '#3c3836',
  lightgray = '#504945',
  inactivegray = '#7c6f64',
}

module.colorscheme = {

  colors = gruvbox_colors,

  tab_bar = {
    background = gruvbox_colors.darkgray,
    inactive_tab_edge = '#575757',
    inactive_tab_edge_hover = gruvbox_colors.darkgray,
    active_tab = {
      bg_color = gruvbox_colors.inactivegray,
      fg_color = gruvbox_colors.black,
    },
    inactive_tab = {
      bg_color = gruvbox_colors.darkgray,
      fg_color = gruvbox_colors.white,
    },
    inactive_tab_hover = {
      bg_color = gruvbox_colors.white,
      fg_color = gruvbox_colors.lightgray,
    },
    new_tab = {
      bg_color = gruvbox_colors.white,
      fg_color = gruvbox_colors.lightgray,
    },
    new_tab_hover = {
      bg_color = gruvbox_colors.white,
      fg_color = gruvbox_colors.lightgray,
    },
  },
}

return module
