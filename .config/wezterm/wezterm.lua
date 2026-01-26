local wezterm = require('wezterm')
local action = wezterm.action
local colors_module = require('colors')
local scheme = colors_module.colorscheme
local colors = colors_module.colors
local helpers = require('helpers')

-- Define keybindings with descriptions (single source of truth)
-- Format: { mods=, key=, action=, desc= } or { group = 'name' } or omit desc for hidden
local keybinding_defs = {
  { group = 'layout' },
  {
    mods = 'CMD',
    key = 't',
    action = wezterm.action_callback(function(window, pane)
      local tab = window:active_tab()
      local tabs = window:mux_window():tabs()
      local current_idx = 0
      for i, t in ipairs(tabs) do
        if t:tab_id() == tab:tab_id() then
          current_idx = i - 1 -- 0-indexed
          break
        end
      end
      window:perform_action(action.SpawnTab('CurrentPaneDomain'), pane)
      window:perform_action(action.MoveTab(current_idx + 1), pane)
    end),
  },
  { mods = 'CMD', key = 'w', action = action.CloseCurrentTab({ confirm = true }), desc = 'close current tab' },
  { mods = 'LEADER|SHIFT', key = 't', action = action.ShowTabNavigator, desc = 'switch tabs (fuzzy)' },
  { mods = 'LEADER', key = 'v', action = action.SplitHorizontal, desc = 'split pane right' },
  { mods = 'LEADER', key = 'x', action = action.SplitVertical, desc = 'split pane down' },
  { mods = 'LEADER', key = 'w', action = action.PaneSelect, desc = 'pick pane by label' },
  { mods = 'LEADER', key = 'z', action = action.TogglePaneZoomState, desc = 'toggle pane fullscreen' },
  { mods = 'CMD', key = 'h', action = action.ActivatePaneDirection('Left'), desc = 'focus pane left' },
  { mods = 'CMD', key = 'l', action = action.ActivatePaneDirection('Right'), desc = 'focus pane right' },
  { mods = 'CMD', key = 'k', action = action.ActivatePaneDirection('Up'), desc = 'focus pane up' },
  { mods = 'CMD', key = 'j', action = action.ActivatePaneDirection('Down'), desc = 'focus pane down' },
  { mods = 'CMD|SHIFT', key = 'h', action = action.AdjustPaneSize({ 'Left', 5 }), desc = 'grow pane left' },
  { mods = 'CMD|SHIFT', key = 'l', action = action.AdjustPaneSize({ 'Right', 5 }), desc = 'grow pane right' },
  { mods = 'CMD|SHIFT', key = 'k', action = action.AdjustPaneSize({ 'Up', 5 }), desc = 'grow pane up' },
  { mods = 'CMD|SHIFT', key = 'j', action = action.AdjustPaneSize({ 'Down', 5 }), desc = 'grow pane down' },

  { group = 'navigation' },
  { mods = 'OPT', key = 'LeftArrow', action = action.SendString('\x1bb'), desc = 'jump word backward' },
  { mods = 'OPT', key = 'RightArrow', action = action.SendString('\x1bf'), desc = 'jump word forward' },
  { mods = 'CMD', key = 'Backspace', action = action.SendString('\x15'), desc = 'delete to line start' },
  { mods = 'CMD|SHIFT', key = 'UpArrow', action = action.ScrollToPrompt(-1), desc = 'jump to prev prompt' },
  { mods = 'CMD|SHIFT', key = 'DownArrow', action = action.ScrollToPrompt(1), desc = 'jump to next prompt' },

  { group = 'workspaces' },
  {
    mods = 'LEADER',
    key = 's',
    action = action.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }),
    desc = 'switch workspace (fuzzy)',
  },
  {
    mods = 'LEADER',
    key = 'n',
    action = action.PromptInputLine({
      description = 'Enter new workspace name',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(action.SwitchToWorkspace({ name = line }), pane)
        end
      end),
    }),
    desc = 'create named workspace',
  },

  { group = 'selection & copy' },
  { mods = 'CMD|SHIFT', key = 'x', action = action.ActivateCopyMode, desc = 'enter vim-style selection' },
  { mods = 'LEADER', key = 'Space', action = action.ActivateCopyMode, desc = 'enter vim-style selection' },
  { mods = 'CTRL', key = 'Space', action = action.QuickSelect, desc = 'select visible text hints' },
  {
    mods = 'CTRL',
    key = 'O',
    action = action.QuickSelectArgs({
      label = 'open url',
      patterns = { 'https?://\\S+' },
      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        wezterm.log_info('opening: ' .. url)
        wezterm.open_with(url)
      end),
    }),
    desc = 'select & open url',
  },

  -- Hidden (no desc = not shown in help)
  { mods = 'CMD', key = 'm', action = 'DisableDefaultAssignment' },
}

-- Build keys table from definitions (skip group markers and display-only entries)
local function build_keys(defs)
  local keys = {}
  for _, def in ipairs(defs) do
    if not def.group and def.mods and def.action then
      table.insert(keys, { mods = def.mods, key = def.key, action = def.action })
    end
  end
  return keys
end

local keys = build_keys(keybinding_defs)

-- Build help text for display
local keybindings_help = helpers.build_help(keybinding_defs, {
  { binding = 'LEADER + ?', desc = 'show this cheatsheet' },
})

-- Add help keybinding - opens in tab, centered, press any key to close
table.insert(keys, {
  mods = 'LEADER',
  key = '?',
  action = action.SpawnCommandInNewTab({
    args = {
      'bash',
      '-c',
      [[
        clear
        text=]]
        .. wezterm.shell_quote_arg(keybindings_help)
        .. [[

        # Get terminal dimensions
        cols=$(tput cols)
        lines=$(tput lines)

        # Count text lines and max width
        text_lines=$(printf '%s' "$text" | wc -l)
        max_width=$(printf '%s\n' "$text" | while IFS= read -r line; do printf '%d\n' "${#line}"; done | sort -rn | head -1)

        # Calculate padding
        pad_top=$(( (lines - text_lines) / 2 ))
        pad_left=$(( (cols - max_width) / 2 ))

        # Print vertical padding
        for ((i=0; i<pad_top; i++)); do echo; done

        # Print each line with horizontal padding
        printf '%s\n' "$text" | while IFS= read -r line; do
          printf "%${pad_left}s%s\n" "" "$line"
        done

        read -rsn1
      ]],
    },
  }),
})

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

wezterm.on('format-tab-title', function(tab, tabs, _, _, hover, _)
  local background = scheme.tab_bar.inactive_tab.bg_color
  local foreground = scheme.tab_bar.inactive_tab.fg_color
  local italic = false

  local is_first = tab.tab_id == tabs[1].tab_id
  local is_last = tab.tab_id == tabs[#tabs].tab_id

  if tab.is_active then
    background = scheme.tab_bar.active_tab.bg_color
    foreground = scheme.tab_bar.active_tab.fg_color
  elseif tab.is_last_active then
    -- Subtle indicator for previously active tab
    background = colors.lightgray
    foreground = colors.white
    italic = true
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
    { Attribute = { Italic = italic } },
    { Attribute = { Intensity = hover and 'Bold' or 'Normal' } },
    { Background = { Color = leading_bg } },
    { Foreground = { Color = leading_fg } },
    { Text = SOLID_RIGHT_ARROW },
    { Background = { Color = background } },
    { Text = ' ' .. helpers.get_process(tab) },
    { Foreground = { Color = foreground } },
    { Text = ' ' .. title .. ' ' },
    { Background = { Color = trailing_bg } },
    { Foreground = { Color = trailing_fg } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

wezterm.on('update-status', function(window, pane)
  -- Each element holds the text for a cell in a "powerline" style << fade
  local cells = {}

  -- Show progress if available (ConEmu-style progress sequences)
  local progress = pane:get_progress()
  if progress and progress.current then
    table.insert(cells, string.format('%d%%', progress.current))
  end

  -- Figure out the cwd and host of the current pane.
  -- This will pick up the hostname for the remote host if your
  -- shell is using OSC 7 on the remote host.
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    local cwd = ''
    local hostname = ''

    cwd = cwd_uri.file_path
    hostname = cwd_uri.host or wezterm.hostname()

    -- Remove the domain name portion of the hostname
    local dot = hostname:find('[.]')
    if dot then
      hostname = hostname:sub(1, dot - 1)
    end
    if hostname == '' then
      hostname = wezterm.hostname()
    end

    local contracted_cwd = helpers.contract_path(cwd)

    table.insert(cells, contracted_cwd)
    table.insert(cells, hostname)
  end

  -- Set UTC Datetime
  local date = wezterm.strftime_utc('%Y-%m-%d %H:%M UTC')
  -- local tz = wezterm.strftime(' (%z)')
  table.insert(cells, date) --.. tz)

  -- An entry for each battery (typically 0 or 1 battery)
  for _, b in ipairs(wezterm.battery_info()) do
    table.insert(cells, string.format('%.0f%%', b.state_of_charge * 100))
  end

  -- Color palette for the backgrounds of each cell
  local bg_colors = {
    colors.black,
    colors.darkgray,
    colors.lightgray,
    colors.inactivegray,
  }

  -- Foreground color for the text across the fade
  local text_fg = colors.white

  -- The elements to be formatted
  local elements = {}
  -- How many cells have been formatted
  local num_cells = 0

  -- Translate a cell into elements
  local function push(text, is_last)
    local cell_no = num_cells + 1
    local bg_color = bg_colors[math.min(cell_no, #bg_colors)]
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Background = { Color = bg_color } })
    table.insert(elements, { Text = ' ' .. text .. ' ' })
    if not is_last then
      local next_color = bg_colors[math.min(cell_no + 1, #bg_colors)]
      table.insert(elements, { Foreground = { Color = next_color } })
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
local hostname = wezterm.hostname()
if hostname:find('^BLK') then
  font_size = 18
else
  font_size = 16.5
end

--local font = 'Input'
--local font = 'SauceCodePro Nerd Font'
local font = 'Iosevka Term'

return {
  -- appearance
  adjust_window_size_when_changing_font_size = false,
  --color_scheme = 'GruvboxDark (Gogh)',
  color_scheme = 'GruvboxDark',
  font = wezterm.font(font, { stretch = 'Expanded', weight = 'Regular' }),
  font_size = font_size,
  scrollback_lines = 1000000,

  window_frame = {
    font = wezterm.font(font, { weight = 'Bold' }),
  },

  -- Use Iosevka for PaneSelect overlay
  pane_select_font = wezterm.font(font, { stretch = 'Expanded', weight = 'Regular' }),

  -- Center content when window isn't a perfect cell multiple
  window_content_alignment = { horizontal = 'Center', vertical = 'Center' },

  -- Pixel-perfect box drawing, git symbols, progress bars
  custom_block_glyphs = true,

  foreground_text_hsb = {
    hue = 1.0,
    saturation = 1.1,
    brightness = 1.1,
  },

  -- Dim inactive panes for visual distinction
  inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.7,
  },

  tab_max_width = 64,
  use_fancy_tab_bar = false,
  enable_tab_bar = true,

  max_fps = 240,

  -- Strip colors during QuickSelect for better match visibility
  quick_select_remove_styling = true,

  default_prog = { '/bin/zsh', '-l' },

  -- Multiplexer domain for session persistence (connect with: wezterm connect unix)
  unix_domains = { { name = 'unix' } },

  -- leader option CMD + ,
  -- similar to my neovim config of ,
  leader = {
    mods = 'CMD',
    key = ',',
    timeout_milliseconds = 1000,
  },

  keys = keys,

  mouse_bindings = {
    -- CMD-click will open the link under the mouse cursor
    {
      mods = 'CMD',
      event = { Up = { streak = 1, button = 'Left' } },
      action = action.OpenLinkAtMouseCursor,
    },
  },
}
