-- Put this at the top of any test
local ppath = package.path..';..\\?.lua;'
package.path = ppath;

require "GameWindow"

function ontick(win, tickCount)
	win.GDIContext:Text("Hello, Lua World!", 50, 80)

	local stats = string.format("Frame: %d", tickCount)
	win.GDIContext:Text(stats)
end

local appwin = GameWindow({Title = "Hello Window", OnTickDelegate=ontick})

appwin:Run()


