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

function ontick(win, tickCount)

	for i=1,win.FrameRate do
		local x1 = math.random() * win.Width
		local y1 = 40 + (math.random() * (win.Height - 40))
		local x2 = math.random() * win.Width
		local y2 = 40 + (math.random() * (win.Height - 40))

		local r = math.random(0,255)
		local g = math.random(0,255)
		local b = math.random(0,255)
		local color = RGB(r,g,b)

		win.GDIContext:SetDCPenColor(color)

		win.GDIContext:MoveTo(x1, y1)
		win.GDIContext:LineTo(x2, y2)
	end

	local stats = string.format("Seconds: %f  Frame: %d  FPS: %f", sw:Seconds(), tickCount, tickCount/sw:Seconds())
	win.GDIContext:Text(stats)
	win.GDIContext:Flush()
end


wgl = {}
function wgl_lookup(funcName)
	local funcPtr = gl.wglGetProcAddress(funcName)
	local success = funcPtr ~= nil

	return funcPtr, success
end

-- This function is called whenever something
-- is not found in the table.  We lookup the function
-- and if found, we add it to the table.
--
-- After it's added to the table, it will not be looked
-- up again here.
--
function wgl_index(tbl, str)
	print("wgl_index: ", tbl, str)

	-- by definition, the string should
	-- not be found in the table
--	local funcPtr = rawget(tbl, str)
--	if funcPtr then
--		print("FOUND IN TABLE")
--		return funcPtr
--	end

	-- Try to get the address of the function
	-- add it to the table
	-- this is correct, even if the function is null
	local funcPtr, success = wgl_lookup(str)

	print("INSERTING INTO TABLE: ", funcPtr, success)
	rawset(tbl, str, funcPtr)

	-- If the function was found, then return the
	-- pointer to that function.
	-- Otherwise, return null
	if success then
		return funcPtr
	else
		return nil
	end
end

wgl_mt = {
	__index = wgl_index
}
setmetatable(wgl, wgl_mt)



function test_wgl(msg)
	print(string.format("test_wgl: 0x%x", msg.message))
	print(msg.hwnd)


	local hDC = C.GetDC(msg.hwnd)

	local func1 = wgl.wglGetExtensionsStringARB
	print("WGL (wglGetExtensionsStringARB) 1: ", func1)

--local func2 = ffi.cast("PFNWGLGETEXTENSIONSSTRINGARBPROC", wgl.wglGetExtensionsStringARB)
--print("WGL (wglGetExtensionsStringARB) 2: ", func2)

--local str = func2(hDC)
--print("String: ",str)

--local wglstr = gllib.wglGetExtensionsStringARB(hDC)
--print("WGL Extensions: ", wglstr)

end



function main()
	-- MouseInteractor = mouseinteraction,

	local appwin = GameWindow({
		Title = "Game Window",
		KeyboardInteractor = keyboardinteraction,
		FrameRate = 60,
		OnTickDelegate = ontick,
		Extent = {1024,768},
		})

	appwin.GDIContext:SelectStockObject(C.DC_PEN)


	appwin:Run()
end

main()
