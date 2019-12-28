# Some Useful Spoons for Hammerspoon

Provide some useful Spoons.

## LaunchITerm2.spoon

Quick Launch or focus `iTerm2` through shortcut (default <kbd>F12</kbd>), and when press that shortcut again, quick focus previous application. Usage:
```lua
-- In your ~/.hammerspoon/init.lua

LaunchITerm2 = hs.loadSpoon('LaunchITerm2')

-- You can custom shortcut if F12 is not what you want
LaunchITerm2:bindHotKeys({
  toggle={{'fn'}, 'F11'}
})

LaunchITerm2:start()
```
