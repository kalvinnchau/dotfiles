local wezterm = require('wezterm')
local action = wezterm.action
local scheme = require('colors').colorscheme
local helpers = require('helpers')

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

wezterm.on('format-tab-title', function(tab, tabs, _, _, hover, _)
  local background = scheme.tab_bar.inactive_tab.bg_color
  local foreground = scheme.tab_bar.inactive_tab.fg_color

  local is_first = tab.tab_id == tabs[1].tab_id
  local is_last = tab.tab_id == tabs[#tabs].tab_id

  if tab.is_active then
    background = scheme.tab_bar.active_tab.bg_color
    foreground = scheme.tab_bar.active_tab.fg_color
  elseif hover then
    background = scheme.tab_bar.new_tab_hover.bg_color
    foreground = scheme.tab_bar.new_tab_hover.fg_color
  end

  local leading_fg = scheme.tab_bar.inactive_tab.fg_color
  local leading_bg = background

  local trailing_fg = background
  local trailing_bg = scheme.tab_bar.inactive_tab.bg_color

  if is_first then
    leading_fg = background
    leading_bg = background
  else
    leading_fg = scheme.tab_bar.inactive_tab.bg_color
  end

  if is_last then
    trailing_bg = scheme.tab_bar.background
  else
    trailing_bg = scheme.tab_bar.inactive_tab.bg_color
  end

  local title = tab.active_pane.title

  return {
    { Attribute = { Italic = false } },
    { Attribute = { Intensity = hover and "Bold" or "Normal" } },
    { Background = { Color = leading_bg } },
    { Foreground = { Color = leading_fg } },
    { Text = SOLID_RIGHT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = " " .. title .. " " },
    { Background = { Color = trailing_bg } },
    { Foreground = { Color = trailing_fg } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

wezterm.on('update-right-status', function(window, pane)
  -- Each element holds the text for a cell in a "powerline" style << fade
  local cells = {}

  -- Figure out the cwd and host of the current pane.
  -- This will pick up the hostname for the remote host if your
  -- shell is using OSC 7 on the remote host.
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    cwd_uri = cwd_uri:sub(8)
    local slash = cwd_uri:find '/'
    local cwd = ''
    local hostname = ''
    if slash then
      hostname = cwd_uri:sub(1, slash - 1)
      -- Remove the domain name portion of the hostname
      local dot = hostname:find '[.]'
      if dot then
        hostname = hostname:sub(1, dot - 1)
      end
      -- and extract the cwd from the uri
      cwd = cwd_uri:sub(slash)
      local contracted_cwd = helpers.contract_path(cwd)

      table.insert(cells, contracted_cwd)
      if hostname ~= "" then
        table.insert(cells, hostname)
      end
    end
  end

  -- Set UTC Datetime
  local date = wezterm.strftime_utc '%Y-%m-%d %H:%M UTC'
  table.insert(cells, date)

  -- An entry for each battery (typically 0 or 1 battery)
  for _, b in ipairs(wezterm.battery_info()) do
    table.insert(cells, string.format('%.0f%%', b.state_of_charge * 100))
  end

  -- Color palette for the backgrounds of each cell
  local colors = {
    scheme.colors.black,
    scheme.colors.darkgray,
    scheme.colors.lightgray,
    scheme.colors.inactivegray,
  }

  -- Foreground color for the text across the fade
  local text_fg = scheme.colors.white

  -- The elements to be formatted
  local elements = {}
  -- How many cells have been formatted
  local num_cells = 0

  -- Translate a cell into elements
  local function push(text, is_last)
    local cell_no = num_cells + 1
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Background = { Color = colors[cell_no] } })
    table.insert(elements, { Text = ' ' .. text .. ' ' })
    if not is_last then
      table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
      table.insert(elements, { Text = SOLID_LEFT_ARROW })
    end
    num_cells = num_cells + 1
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell, #cells == 0)
  end

  window:set_right_status(wezterm.format(elements))
end)

local font_size
if wezterm.hostname() == 'LP-KCHAU2-OSX' then
  font_size = 23.5
else
  font_size = 16.5
end

return {
  -- appearance
  adjust_window_size_when_changing_font_size = false,
  color_scheme = "GruvboxDark (Gogh)",
  --color_scheme = "Gruvbox Dark",
  font = wezterm.font(
    'SauceCodePro Nerd Font'
  ),
  font_size = font_size,
  scrollback_lines = 1000000,

  window_frame = {
    font = wezterm.font(
      'SauceCodePro Nerd Font',
      { weight = 'Bold' }
    ),
  },

  tab_max_width = 64,
  use_fancy_tab_bar = false,
  enable_tab_bar = true,

  default_prog = { '/bin/zsh', '-l' },

  -- leader option CMD + ,
  -- similar to my neovim config of ,
  leader = {
    mods = 'CMD',
    key = ',',
    timeout_milliseconds = 1000
  },

  -- key mappings
  keys = {

    {
      mods = 'OPT',
      key = 'LeftArrow',
      action = action.SendString('\x1bb'),
    },

    {
      mods = 'OPT',
      key = 'RightArrow',
      action = action.SendString('\x1bf'),
    },

    {
      mods = 'CMD',
      key = 'Backspace',
      action = action.SendString('\x15'),
    },

    -- Turn off the default CMD-m Hide action, since we don't use it
    -- timeout_milliseconds defaults to 1000 and can be omitted
    {
      mods = 'CMD',
      key = 'm',
      action = 'DisableDefaultAssignment'
    },

    -- CMD + ',' + v to split SplitHorizontal
    {
      mods = 'LEADER',
      key = 'v',
      action = action.SplitHorizontal,
    },

    -- CMD + ',' + x to split SplitVertical
    {
      mods = 'LEADER',
      key = 'x',
      action = action.SplitVertical,
    },

    {
      mods = 'LEADER',
      key = 'w',
      action = action.PaneSelect,
    },

    -- move between panes with hlkj vim style
    {
      mods = 'CMD',
      key = 'h',
      action = action.ActivatePaneDirection 'Left',
    },
    {
      mods = 'CMD',
      key = 'l',
      action = action.ActivatePaneDirection 'Right',
    },
    {
      mods = 'CMD',
      key = 'k',
      action = action.ActivatePaneDirection 'Up',
    },
    {
      mods = 'CMD',
      key = 'j',
      action = action.ActivatePaneDirection 'Down',
    },

    {
      mods = 'LEADER|SHIFT',
      key = 't',
      action = action.ShowTabNavigator,
    },

    -- Copy mode remapping
    -- https://wezfurlong.org/wezterm/copymode.html
    {
      mods = 'CMD|SHIFT',
      key = 'x',
      action = action.ActivateCopyMode
    },
  },

  mouse_bindings = {
    -- CMD-click will open the link under the mouse cursor
    {
      mods = 'CMD',
      event = { Up = { streak = 1, button = 'Left' } },
      action = action.OpenLinkAtMouseCursor,
    },
  },
}
