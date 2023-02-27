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
  local idx = 1

  for part in string.gmatch(clean_path, '[^/]+') do
    path_parts[idx] = part
    idx = idx + 1
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

return module
