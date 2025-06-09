-- Pull in the wezterm API
local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Fullscreen
wezterm.on('gui-startup', function()
    local tab, pane, window = mux.spawn_window({})
    window:gui_window():maximize()
end)

-- Settings
config.color_scheme = 'Ollie'
config.font = wezterm.font('JetBrains Mono')
config.font_size = 10
config.line_height = 1
config.window_background_opacity = 0.9
config.use_dead_keys = false
config.window_decorations = "RESIZE"
config.scrollback_lines = 3000
config.window_close_confirmation = "AlwaysPrompt"
config.default_domain = 'WSL:Ubuntu-24.04'

-- Dim inactive panes
config.inactive_pane_hsb = {
    saturation = 0.24,
    brightness = 0.5
}

-- Keys
config.keys = {
  {
    key = 'T',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SpawnTab('DefaultDomain'),
  },
  {
    key = 'n',
    mods = 'SHIFT|CTRL',
    action = wezterm.action.ToggleFullScreen,
  },
}

-- Tab bar
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
wezterm.on("update-right-status", function(window, pane)
  -- Workspace name
  local stat = window:active_workspace()
  -- It's a little silly to have workspace name all the time
  -- Utilize this to display LDR or current key table name
  if window:active_key_table() then stat = window:active_key_table() end
  if window:leader_is_active() then stat = "LDR" end

  -- Current working directory
  local basename = function(s)
    -- Nothign a little regex can't fix
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
  end
  local cwd = basename(pane:get_current_working_dir())
  -- Current command
  local cmd = basename(pane:get_foreground_process_name())

  -- Time
  local time = wezterm.strftime("%H:%M")

  -- Let's add color to one of the components
  window:set_right_status(wezterm.format({
    -- Wezterm has a built-in nerd fonts
    { Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
    { Text = " | " },
    { Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
    { Text = " | " },
    { Foreground = { Color = "FFB86C" } },
    { Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
    "ResetAttributes",
    { Text = " | " },
    { Text = wezterm.nerdfonts.md_clock .. "  " .. time },
    { Text = " |" },
  }))
end)

-- Launch menu: WSL, PowerShell, CMD
config.launch_menu = {
  {
    label = "WSL - Ubuntu",
    domain = { DomainName = "WSL:Ubuntu-24.04" }
  },
  {
    label = "PowerShell",
    args = { "powershell.exe" },
    domain = { DomainName = "local" }
  },
  {
    label = "CMD",
    args = { "cmd.exe" },
    domain = { DomainName = "local" }
  },
}

-- and finally, return the configuration to wezterm
return config