runShell = function(command)
  hs.execute(command)
  k.triggered = true
end

-- To log to console: print()

------------------------
-- Caps lock bindings
------------------------

-- A global variable for the Hyper Mode

-- k = hs.hotkey.modal.new({}, "F19")
k = hs.hotkey.modal.new({}, nil, "k")

itermWindows = {
  {'j', 'osascript ~/bin/activate_iterm_tab.scpt serving'},
  {'k', 'osascript ~/bin/activate_iterm_tab.scpt targeting'},
  {'l', 'osascript ~/bin/activate_iterm_tab.scpt connections'},
  {'m', 'osascript ~/bin/activate_iterm_tab.scpt datalab'},
}

function getChromeWindow(nth)
  app = hs.application.get('Google Chrome')

  local windows = {}
  for index, window in pairs(app:allWindows()) do
    table.insert(windows, window)
  end
  function compareWindows(lhs, rhs)
    return lhs:id() < rhs:id()
  end
  table.sort(windows, compareWindows)

  local i = 1
  for index, window in ipairs(windows) do
    if window:isStandard() then
      if i == nth then
        return window
      end
      i = i + 1
    end
  end
  return nil
end

for index, info in ipairs(itermWindows) do
  k:bind({}, info[1], function() runShell(info[2]); end)
end
k:bind({}, 'y', function ()
  getChromeWindow(2):focus()
  k.triggered = true
end)
k:bind({}, 'u', function ()
  getChromeWindow(1):focus()
  k.triggered = true
end)
k:bind({}, 'i', function ()
  -- getChromeWindow(3):focus()
  hs.application.get('Safari'):activate()
  k.triggered = true
end)
k:bind({}, 'o', function ()
  getChromeWindow(3):focus()
  k.triggered = true
end)

-- Enter Hyper Mode when F19 (Hyper/Capslock) is pressed
pressedHyper = function()
  k.triggered = false
  k:enter()
end

-- Leave Hyper Mode when F19 (Hyper/Capslock) is pressed,
--   send ESCAPE if no other keys are pressed.
releasedHyper = function()
  k:exit()
  if not k.triggered then
    hs.eventtap.keyStroke({}, 'ESCAPE')
  end
end

-- Bind the Hyper key
hyper = hs.hotkey.bind({}, 'F19', pressedHyper, releasedHyper)

------------------------
-- Other bindings
------------------------

-- Laggy - for now use BTT
-- hs.hotkey.bind({'alt'}, 'e', function() hs.eventtap.keyStroke({'shift'}, '9'); end, nil)
-- hs.hotkey.bind({'alt'}, 'r', function() hs.eventtap.keyStroke({'shift'}, '0'); end, nil)

------------------------
-- Testing Chrome Selector
------------------------

-- Simple bindings

-- log = hs.logger.new('default', 'debug')
hs.hotkey.bind({'alt'}, 'x', function()
  -- Kind of hacky - get the first Chrome instance and activate it
  -- (Should instead find the one with the right command line)
  hs.application.get('Google Chrome'):activate()
  -- hs.application.get('Google Chrome'):mainWindow():focus()
  -- getChromeWindow(1):focus()
end)

basicBindings = {
  {'t', 'MacVim'},
  {'d', 'iTerm2'},
  {'a', 'IntelliJ IDEA'},
  -- {'w', 'VimWiki'},
  {'q', 'Slack'},
  -- {'t', 'Alacritty'},
}
for index, info in ipairs(basicBindings) do
  hs.hotkey.bind({'alt'}, info[1], function()
    hs.application.get(info[2]):activate()
  end)
end

hs.hotkey.bind({'alt'}, 'z', function()
  target = nil
  for i, app in ipairs(hs.application.runningApplications()) do
    -- Original purpose of this was to find the *first* created Chrome window.
    -- Now see hyper+yui
    -- if app:name() == 'Google Chrome' then
    if app:name() == 'Safari' then
      target = app
    end
  end

  if target ~= nil then
    target:activate()
  end
end)

-- Will need to refactor if we support multiple apps here
lastActiveWindow = nil

function activateWindow(window)
  -- print("Activating " .. window:title())
  lastActiveWindow = window
  lastActiveWindow:focus()
end

function activateNext(current, targetMatchFn)
  local windows = hs.window.allWindows()
  local shouldActivateNext = false
  local firstEligible = nil
  for idx, window in ipairs(windows) do
    if targetMatchFn(window) then
      if not firstEligible then
        firstEligible = window
      end
      if shouldActivateNext then
        -- print("Activating " .. tostring(idx))
        activateWindow(window)
        return
      end
      if window:id() == current:id() then
        shouldActivateNext = true
      end
    end
  end
  if firstEligible then
    -- print("Activating first")
      activateWindow(firstEligible)
  else
    -- print("No window found")
  end
end

function ends_with(item, suffix)
  return suffix == "" or item:sub(-#suffix) == suffix
end

hs.hotkey.bind({'alt'}, 'w', function()
  local targetName = 'Alacritty'
  local targetSuffix = '- VIMWIKI'

  function windowMatches(candidate)
    return (
      candidate:application():name() == targetName and
      ends_with(candidate:title(), targetSuffix))
  end

  local windows = hs.window.allWindows()
  local shouldActivateNext = false
  local firstEligible = nil
  for idx, window in ipairs(windows) do
    if windowMatches(window) then
      -- print("Activating wiki")
      window:focus()
    end
  end
end)

hs.hotkey.bind({'alt'}, 's', function()
  local win = hs.window.focusedWindow()
  -- print("N: " .. win:application():name())
  local targetName = 'Alacritty'
  local targetSuffix = '- NVIM'

  function windowMatches(candidate)
    return (
      candidate ~= nil and
      candidate:application():name() == targetName and
      ends_with(candidate:title(), targetSuffix))
  end
  if windowMatches(win) then
    activateNext(win, windowMatches)
  else
    if lastActiveWindow then
      -- lastActiveWindow fails if the window is closed - need to detect this
      -- and reset
      local windows = hs.window.allWindows()
      for idx, window in ipairs(windows) do
        if window:id() == lastActiveWindow:id() then
          -- print("Activating last")
          activateWindow(lastActiveWindow)
          return
        end
      end
    end
    -- print("Activating any")
    local windows = hs.window.allWindows()
    for idx, window in ipairs(windows) do
      if windowMatches(window) then
        activateWindow(window)
        return
      end
    end
    print("Failed to find any matching windows")
    -- local targetApp = hs.application.get(targetName)
    -- activateWindow(targetApp:allWindows()[1])
  end
end)

------------------------
-- Window size
------------------------

-- Call externally via e.g.
-- `hs -c "windowPosition('center', 'top', 1057, 824, -139)"`
require("hs.ipc")

function windowPosition(
    winOrName, pos_h, pos_v, size_h, size_v, shift_h, shift_v)
  local win
  if winOrName == nil or winOrName == 'cur' then
    win = hs.window.focusedWindow()
  else
    win = winOrName
  end
  shift_h = shift_h or 0
  shift_v = shift_v or 0
  print("Sizing " .. win:title())
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  if size_h == 0 then
    size_h = f.w
  else
    f.w = size_h
  end
  if size_v == 0 then
    size_v = f.h
  else
    f.h = size_v
  end
  -- f.w = size_h
  -- f.h = size_v

  if pos_h == 'center' then
    f.x = max.x + (max.w / 2) - (size_h / 2) + shift_h
  elseif pos_h == 'right' then
    f.x = max.x + max.w - size_h + shift_h
  else
    print("Invalid position h " .. pos_h)
    error("Invalid position h " .. pos_h)
  end
  if pos_v == 'top' then
    f.y = max.y + shift_v
  elseif pos_v == 'bottom' then
    f.y = max.y + max.h - size_v + shift_v
  else
    print("Invalid position v " .. pos_v)
    error("Invalid position v " .. pos_v)
  end
  win:setFrame(f)

  -- Move window to take entire right half of screen
  -- local win = hs.window.focusedWindow()
  -- local f = win:frame()
  -- local screen = win:screen()
  -- local max = screen:frame()
  -- f.x = max.x + (max.w/2)
  -- f.y = max.y
  -- f.w = max.w / 2
  -- f.h = max.h
  -- win:setFrame(f)
end

------------------------
-- Layout
------------------------

-- self.center_window_command('iTerm2', 970, 948),
-- self.center_window_command(
--     self.proc_by_name('MacVim'), 1038, 809, shift_left=139),
-- # self.bottom_right_window_command(
-- #     self.proc_by_name('VimWiki'), 759, 809),
-- self.center_window_command('IntelliJ IDEA', 1424, 1079, shift_left=45),
-- self.top_right_window_command('Slack', 1024, 768),
-- self.center_window_command(
--     'Google Chrome', 1360, 960, app_ignores_size=True),
-- self.center_window_command('Safari', 1360, 960),
function layoutWindows()
  windows = hs.window.allWindows()
  for index, window in pairs(windows) do
    if window:isVisible() then
      local appName = window:application():name()
      if appName == 'Alacritty' then
        -- Custom based on title
        local title = window:title()
        if ends_with(title, '- NVIM') then
          windowPosition(window, 'center', 'top', 1057, 824, -139)
        elseif ends_with(title, '- NVIML') then
          windowPosition(window, 'center', 'top', 1804, 976, 234)
        elseif ends_with(title, '- VIMWIKI') then
          windowPosition(window, 'right', 'bottom', 778, 786)
        else
          print("Ignoring Alacritty window: " .. title)
        end
      elseif appName == 'Google Chrome' then
        windowPosition(window, 'center', 'top', 1360, 960)
      elseif appName == 'IntelliJ IDEA' then
        windowPosition(window, 'center', 'top', 1424, 1079, -45, 0)
      elseif appName == 'MacVim' then
        windowPosition(window, 'center', 'top', 1038, 809, -139, 0)
      elseif appName == 'Safari' then
        windowPosition(window, 'center', 'top', 1360, 960)
      elseif appName == 'Slack' then
        windowPosition(window, 'right', 'top', 1024, 768)
      elseif appName == 'iTerm2' then
        windowPosition(window, 'center', 'top', 970, 948)
      elseif appName == 'VimWiki' then
        windowPosition(window, 'right', 'bottom', 759, 809)
      else
        print("Unknown window " ..
          index .. ", name: " .. window:application():name())
      end
    end
  end
end

hs.hotkey.bind({'cmd', 'alt'}, 'x', function()
  hs.notify.show('Layout', '', 'Laying out windows')
  layoutWindows()
end)
hs.hotkey.bind({'cmd', 'alt'}, 'z', function()
  hs.notify.show('Layout', '', 'Laying out windows')
  layoutWindows()
end)
