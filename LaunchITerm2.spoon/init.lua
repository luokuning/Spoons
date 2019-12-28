--- === LaunchITerm2 ===

local obj = { __gc = true }

setmetatable(obj, obj)
obj.__gc = function(t)
  t:stop()
end

obj.name = 'LaunchITerm2'
obj.version = '1.0'
obj.author = 'LK <i91935058@gmail.com>'
obj.homepage = 'https://github.com/luokuning/Spoons'
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.appName = 'iTerm2'
obj.focusedApp = nil
obj.hotkeyToggle = nil
obj.appWatcher = nil
obj.windowFiler = nil

function obj:init()
  self:bindHotKeys({
    toggle={{'fn'}, 'F12'}
  })
end

function obj:bindHotKeys(mapping)
  if (self.hotkeyToggle) then
    self.hotkeyToggle:delete()
  end

  local toggleMods = mapping["toggle"][1]
  local toggleKey = mapping["toggle"][2]

  self.hotkeyToggle = hs.hotkey.bind(toggleMods, toggleKey, function()
    if hs.window.focusedWindow():application():name() == self.appName and self.focusedApp then
      self.focusedApp:activate()
    else
      hs.application.launchOrFocus('iTerm')

    end
  end)

  return self
end

function obj:start()
  if (self.hotkeyToggle) then
    self.hotkeyToggle:enable()
  end

  self.appWatcher = hs.application.watcher.new(function(appName, eventType, application)
    if appName ~= self.appName and appName ~= 'Hammerspoon' and eventType == hs.application.watcher.deactivated then
      self.focusedApp = application
    end
  end)
  self.appWatcher:start()

  self.windowFiler = hs.window.filter.new(false):setAppFilter(self.appName):subscribe(hs.window.filter.windowCreated, function(window, appName)
    if window:title() == 'iTerm2' then
      local f = window:frame()
      local screen = window:screen()
      local max = screen:frame()

      f.x = max.x
      f.y = max.y
      f.w = max.w
      f.h = max.h / 2

      window:setFrame(f)
    end
  end)

  return self
end

function obj:stop()
  if (self.hotkeyToggle) then
    self.hotkeyToggle:disable()
  end

  self.windowFiler:unsubscribeAll()
  self.appWatcher:stop()

  self.appWatcher = nil
  self.windowFiler = nil

  return self
end

return obj
