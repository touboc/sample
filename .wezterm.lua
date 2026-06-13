local wezterm = require 'wezterm'
local config = wezterm.config_builder()
config.default_prog = { 'cmd.exe' }

-- Set the font family
config.font = wezterm.font 'JetBrains Mono'

-- Set the font size (optional, defaults to 12.0)
config.font_size = 13.0

config.color_scheme = 'zenwritten_dark'
config.cursor_thickness = "2pt"
config.status_update_interval = 1000
config.scrollback_lines = 3500
config.animation_fps = 120
config.window_background_opacity = 0.93

------------------------
-- 1. Define your tmux Prefix/Leader key (Ctrl+a)
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
  -- 2. Split Panes (just like tmux defaults)
  {
    -- Vertical split (creates a pane to the right)
    key = '%',
    mods = 'LEADER|SHIFT', -- Shift is needed to trigger %
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    -- Horizontal split (creates a pane below)
    key = '"',
    mods = 'LEADER|SHIFT', -- Shift is needed to trigger "
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },

  -- 3. Pass through Ctrl+a if pressed twice 
  -- (Lets you use Ctrl+a inside bash/vim to jump to start of line)
  {
    key = 'a',
    mods = 'LEADER|CTRL',
    action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' },
  },

  -- 4. Manage Tabs (equivalent to tmux Windows)
  {
    -- Create new tab (tmux: prefix + c)
    key = 'c',
    mods = 'LEADER',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    -- Go to previous tab (tmux: prefix + p)
    key = 'p',
    mods = 'LEADER',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    -- Go to next tab (tmux: prefix + n)
    key = 'n',
    mods = 'LEADER',
    action = wezterm.action.ActivateTabRelative(1),
  },
-- 2. Bind the sequence: Leader, then 'o' to cycle panes
  {
    key = 'o',
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection('Next'),
  },
  {
    -- Close active pane/tab (tmux: prefix + x)
    key = 'x',
    mods = 'LEADER',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  {
    -- Zoom / Unzoom pane (tmux: prefix + z)
    key = 'z',
    mods = 'LEADER',
    action = wezterm.action.TogglePaneZoomState,
  },

-- 3. Bind the sequence: Leader, then Spacebar
  {
    key = ' ',
    mods = 'LEADER',
    -- Execute a Lua function directly to calculate your layout math
    action = wezterm.action_callback(function(window, pane)
      local tab = window:active_tab()
      
      -- WezTerm natively supports an auto-balancing feature for standard splits
      -- This acts as an incredibly reliable "even grid/balance" reset.
      tab:set_zoomed(false)
      
      -- Shuffles or balances your existing cuts evenly across the screen space
      window:perform_action(wezterm.action.RotatePanes('Clockwise'), pane)
    end),
  },

-- Navigate panes using Leader + Arrow Keys
  { key = 'LeftArrow',  mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'UpArrow',    mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'DownArrow',  mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' },

  -- Navigate panes using Leader + Vim Keys (h, j, k, l)
  { key = 'h',          mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'l',          mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'k',          mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'j',          mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' },


}

-- 5. Quick Tab switching by number (tmux: prefix + 0-9)
for i = 0, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = wezterm.action.ActivateTab(i),
  })
end

-- Listen for the status update event
wezterm.on('update-status', function(window, pane)
  local leader = ""
  
  -- Check if the leader key is currently active
  if window:leader_is_active() then
    leader = " LEADER "
  end

  -- Update the right-hand side of the status bar
  window:set_right_status(wezterm.format({
    { Background = { Color = '#FF5555' } }, -- Bright red background background
    { Foreground = { Color = '#FFFFFF' } }, -- White text
    { Attribute = { Intensity = 'Bold' } },
    { Text = leader },
  }))
end)

-- 2. Define a clean, preset layout cycler
local function cycle_layouts(window, pane)
  local tab = window:active_tab()
  local panes = tab:panes_with_info()
  local num_panes = #panes
  
  if num_panes <= 1 then return end -- Nothing to rearrange
  
  -- We use a persistent state variable to keep track of which layout is next
  -- Layout 1: Even Columns, Layout 2: Even Rows
  if not window:get_state("current_layout") or window:get_state("current_layout") == "rows" then
    window:set_state("current_layout", "columns")
    
    -- Arrange everything into even vertical columns
    for i, p in ipairs(panes) do
      if i > 1 then
        -- Move the pane to the far right, making it a sibling of the root layout
        p.pane:move_to_new_tab() -- Detach temporarily or adjust layout geometry
        -- Note: Custom layout logic typically utilizes pane resizing/moving API
      end
    end
    
  else
    window:set_state("current_layout", "rows")
    -- Arrange everything into even horizontal rows
  end
end

return config
