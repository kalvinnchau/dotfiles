-- random helper functions
local module = {}
local wezterm = require('wezterm')
local scheme = require('colors').colorscheme

local function strip_home(path)
  local username = os.getenv("USER")
  return path:gsub("/Users/" .. username, "~")
end

-- manipulate the input path to truncate the beginning paths
-- with the following rules
-- 1. replace HOME with ~
-- 2. keep only the first character of the dir
-- 3. if dir starts with '.' add the next character
-- 4. keep the full name of the directory we are in
function module.contract_path(path)
  local clean_path = strip_home(path)
  local path_parts = {}

  for part in string.gmatch(clean_path, '[^/]+') do
    table.insert(path_parts, part)
  end

  local short_cwd = ''
  if path_parts[1] ~= '~' then
    short_cwd = '/'
  end

  for i, part in ipairs(path_parts) do
    if i == #path_parts then
      short_cwd = short_cwd .. part
    else
      local path_char = string.sub(part, 1, 1)
      if path_char == '.' then
        path_char = string.sub(part, 1, 2)
      end
      short_cwd = short_cwd .. path_char .. '/'
    end
  end

  return short_cwd
end

--[[
get_process
  uses the tab object to get the process name and replace
  the process with a specific icon if available
  otherwise we just print [process_name] in blue
--]]
function module.get_process(tab)
  local process_icons = {
    ['docker'] = {
      { Foreground = { Color = scheme.colors.blue } },
      { Text = wezterm.nerdfonts.linux_docker },
    },
    ['docker-compose'] = {
      { Foreground = { Color = scheme.colors.blue } },
      { Text = wezterm.nerdfonts.linux_docker },
    },
    ['nvim'] = {
      { Foreground = { Color = scheme.colors.green } },
      { Text = wezterm.nerdfonts.custom_vim },
    },
    ['vim'] = {
      { Foreground = { Color = scheme.colors.green } },
      { Text = wezterm.nerdfonts.dev_vim },
    },
    ['node'] = {
      { Foreground = { Color = scheme.colors.green } },
      { Text = wezterm.nerdfonts.mdi_hexagon },
    },
    ['zsh'] = {
      { Foreground = { Color = scheme.colors.orange } },
      { Text = wezterm.nerdfonts.dev_terminal },
    },
    ['bash'] = {
      { Foreground = { Color = scheme.colors.gray } },
      { Text = wezterm.nerdfonts.cod_terminal_bash },
    },
    ['cargo'] = {
      { Foreground = { Color = scheme.colors.red } },
      { Text = wezterm.nerdfonts.dev_rust },
    },
    ['go'] = {
      { Foreground = { Color = scheme.colors.blue } },
      { Text = wezterm.nerdfonts.mdi_language_go },
    },
    ['git'] = {
      { Foreground = { Color = scheme.colors.green } },
      { Text = wezterm.nerdfonts.dev_git },
    },
    ['lua'] = {
      { Foreground = { Color = scheme.colors.blue } },
      { Text = wezterm.nerdfonts.seti_lua },
    },
    ['curl'] = {
      { Foreground = { Color = scheme.colors.yellow } },
      { Text = wezterm.nerdfonts.mdi_flattr },
    },
    ['kubectl'] = {
      { Foreground = { Color = scheme.colors.yellow } },
      { Text = '\u{f10fe}' }, -- k8s symbol
    },
    ['aws'] = {
      { Foreground = { Color = scheme.colors.yellow } },
      { Text = wezterm.nerdfonts.dev_aws },
    },
  }

  local process_name = string.gsub(tab.active_pane.foreground_process_name, '(.*[/\\])(.*)', '%2')

  return wezterm.format(process_icons[process_name] or {
    { Foreground = { Color = scheme.colors.blue } },
    { Text = string.format('[%s]', process_name) },
  })
end

-- Pretty key name mappings
local key_display = {
  LeftArrow = '←', RightArrow = '→', UpArrow = '↑', DownArrow = '↓',
  Space = 'Space', Backspace = 'Backspace', Return = 'Return', Tab = 'Tab',
}

-- Calculate display width (handles multi-byte UTF-8 chars like arrows)
local function display_width(str)
  return utf8.len(str) or #str
end

-- Pad string to target display width
local function pad_right(str, width)
  local current = display_width(str)
  local padding = width - current
  if padding > 0 then
    return str .. string.rep(' ', padding)
  end
  return str
end

-- Build help text from keybinding definitions
-- Format: { mods=, key=, action=, desc= } or { group = 'Group Name' }
function module.build_help(defs, extra_lines)
  extra_lines = extra_lines or {}

  -- First pass: calculate max widths and build entries
  local max_key_width = 3   -- "Key"
  local max_desc_width = 6  -- "Action"

  local entries = {}
  for _, def in ipairs(defs) do
    if def.group then
      -- Group header
      table.insert(entries, { group = def.group })
      max_key_width = math.max(max_key_width, display_width(def.group))
    elseif def.desc then
      -- Keybinding with description
      local mods = def.mods:gsub('|', '+')
      local key = key_display[def.key] or def.key
      local binding = mods .. ' + ' .. key
      table.insert(entries, { binding = binding, desc = def.desc })
      max_key_width = math.max(max_key_width, display_width(binding))
      max_desc_width = math.max(max_desc_width, display_width(def.desc))
    end
  end

  -- Add extra lines to width calculation
  for _, line in ipairs(extra_lines) do
    if line.group then
      max_key_width = math.max(max_key_width, display_width(line.group))
    else
      max_key_width = math.max(max_key_width, display_width(line.binding))
      max_desc_width = math.max(max_desc_width, display_width(line.desc))
    end
  end

  -- Build table with dynamic widths
  local key_w = max_key_width + 2   -- padding
  local desc_w = max_desc_width + 2
  local total_w = key_w + desc_w + 3  -- borders

  local h_line = string.rep('─', key_w)
  local d_line = string.rep('─', desc_w)

  local lines = {
    '┌' .. h_line .. '┬' .. d_line .. '┐',
    '│ ' .. pad_right('key', key_w - 2) .. ' │ ' .. pad_right('action', desc_w - 2) .. ' │',
  }

  local first_group = true
  for _, entry in ipairs(entries) do
    if entry.group then
      table.insert(lines, '├' .. h_line .. '┼' .. d_line .. '┤')
      table.insert(lines, '│ ' .. pad_right(entry.group, key_w - 2) .. ' │ ' .. pad_right('', desc_w - 2) .. ' │')
      table.insert(lines, '├' .. h_line .. '┼' .. d_line .. '┤')
      first_group = false
    else
      if first_group then
        table.insert(lines, '├' .. h_line .. '┼' .. d_line .. '┤')
        first_group = false
      end
      local line = '│ ' .. pad_right(entry.binding, key_w - 2) .. ' │ ' .. pad_right(entry.desc, desc_w - 2) .. ' │'
      table.insert(lines, line)
    end
  end

  -- Add extra lines
  if #extra_lines > 0 then
    for _, entry in ipairs(extra_lines) do
      if entry.group then
        table.insert(lines, '├' .. h_line .. '┼' .. d_line .. '┤')
        table.insert(lines, '│ ' .. pad_right(entry.group, key_w - 2) .. ' │ ' .. pad_right('', desc_w - 2) .. ' │')
        table.insert(lines, '├' .. h_line .. '┼' .. d_line .. '┤')
      else
        local line = '│ ' .. pad_right(entry.binding, key_w - 2) .. ' │ ' .. pad_right(entry.desc, desc_w - 2) .. ' │'
        table.insert(lines, line)
      end
    end
  end

  table.insert(lines, '└' .. h_line .. '┴' .. d_line .. '┘')
  table.insert(lines, '')
  local leader_text = 'leader = CMD + ,'
  local close_text = 'press any key to close'
  table.insert(lines, string.rep(' ', math.max(0, math.floor((total_w - #leader_text) / 2))) .. leader_text)
  table.insert(lines, string.rep(' ', math.max(0, math.floor((total_w - #close_text) / 2))) .. close_text)

  return table.concat(lines, '\n') .. '\n'
end

return module
