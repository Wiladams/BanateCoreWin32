-- Put this at the top of any test
local ppath = package.path..';..\\?.lua;..\\core\\?.lua;'
package.path = ppath;

local ffi = require "ffi"
local C = ffi.C

require "GameWindow"
require "win_gdi32"
local gl    = require( "gl" )
local wgl = require "gl_wgl"
require "StopWatch"

-- The routine that gets called for any
-- mouse activity messages
function mouseinteraction(msg)
	print(string.format("Mouse: 0x%x", msg.message))
end

function keyboardinteraction(msg)
	print(string.format("Keyboard: 0x%x", msg.message))
	--if msg.message == C.WM_KEYUP then
	--	test_wgl(msg)
	--end
end

local sw = StopWatch()

function randomColor()
		local r = math.random(0,255)
		local g = math.random(0,255)
		local b = math.random(0,255)
		local color = RGB(r,g,b)

	return color
end

function randomline(win)
	local x1 = math.random() * win.Width
	local y1 = 40 + (math.random() * (win.Height - 40))
	local x2 = math.random() * win.Width
	local y2 = 40 + (math.random() * (win.Height - 40))

	local color = randomColor()

	win.GDIContext:SetDCPenColor(color)

	win.GDIContext:MoveTo(x1, y1)
	win.GDIContext:LineTo(x2, y2)
end

function randomrect(win)
	local width = math.random(2,40)
	local height = math.random(2,40)
	local x = math.random(0,win.Width-1-width)
	local y = math.random(0, win.Height-1-height)
	local right = x + width
	local bottom = y + height
--print(x,y,width,height)
	local brushColor = randomColor()
	win.GDIContext:SetDCBrushColor(brushColor)
	win.GDIContext:RoundRect(x, y, right, bottom, 0, 0)
end


function ontick(win, tickCount)
	local black = RGB(0,0,0)
	win.GDIContext:SetDCPenColor(black)

	randomrect(win)

	for i=1,win.FrameRate do
		randomline(win)
	end

	local stats = string.format("Seconds: %f  Frame: %d  FPS: %f", sw:Seconds(), tickCount, tickCount/sw:Seconds())
	win.GDIContext:Text(stats)
end


function main()
	-- MouseInteractor = mouseinteraction,

--[[
	local appwin = GameWindow({
		Title = "Game Window",
		KeyboardInteractor = keyboardinteraction,
		FrameRate = 24.97,
		OnTickDelegate = ontick,
		Extent = {1024,768},
		})
--]]

	local appwin = GameWindow({OnTickDelegate = ontick, Extent = {1024,768},})

	appwin:Run()
end

main()
