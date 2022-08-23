-- random helper functions
local module = {}

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

return module
