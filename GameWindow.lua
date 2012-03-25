--
-- GameWindow.lua
--


local bit = require "bit"
local bor = bit.bor

local ffi = require "ffi"
local C = ffi.C

local class = require "class"

local gl = require "gl"

require "win_gdi32"
require "win_user32"
require "win_kernel32"
require "win_opengl32"
require "StopWatch"

local user32 = ffi.load("User32")
local kernel32 = ffi.load("Kernel32")
local gdi32 = ffi.load("gdi32")
local opengl32 = ffi.load("opengl32")

class.GameWindow()

GameWindow.Defaults = {
	ClassName = "LuaWindow",
	Title = "Game Window",
	Origin = {10,10},
	Extent = {320, 240},
	FrameRate = 30,
}
GameWindow.WindowMap = {}

function GameWindow:_init(params)
	params = params or GameWindow.Defaults

	params.ClassName = params.ClassName or GameWindow.Defaults.ClassName
	params.Title = params.Title or GameWindow.Defaults.Title
	params.Origin = params.Origin or GameWindow.Defaults.Origin
	params.Extent = params.Extent or GameWindow.Defaults.Extent
	params.FrameRate = params.FrameRate or GameWindow.Defaults.FrameRate

	self.Registration = nil
	self.IsReady = false
	self.IsValid = false
	self.IsRunning = false

	self.FrameRate = params.FrameRate
	self.Interval =1/ self.FrameRate

	-- Interactor routines
	self.MessageDelegate = params.MessageDelegate
	self.OnSetFocusDelegate = params.OnSetFocusDelegate
	self.OnTickDelegate = params.OnTickDelegate

	self.KeyboardInteractor = params.KeyboardInteractor
	self.MouseInteractor = params.MouseInteractor
	self.GestureInteractor = params.GestureInteractor

	self:Register(params)
	self:CreateWindow(params)
end

function GameWindow:GetClientSize()
	local csize = ffi.new( "RECT[1]" )
    user32.GetClientRect(self.WindowHandle, csize);
	csize = csize[0]
	local width = csize.right-csize.left
	local height = csize.bottom-csize.top

	return width, height
end


function GameWindow:SetFrameRate(rate)
	self.FrameRate = rate
	self.Interval = 1/self.FrameRate
end






function GameWindow:Register(params)
	self.AppInstance = kernel32.GetModuleHandleA(nil)
	self.ClassName = params.ClassName

	local classStyle = bit.bor(C.CS_HREDRAW, C.CS_VREDRAW, C.CS_OWNDC);

	local aClass = ffi.new('WNDCLASSEXA', {
		cbSize = ffi.sizeof("WNDCLASSEXA");
		style = classStyle;
		lpfnWndProc = WindowProc;
		cbClsExtra = 0;
		cbWndExtra = 0;
		hInstance = self.AppInstance;
		hIcon = nil;
		hCursor = nil;
		hbrBackground = nil;
		lpszMenuName = nil;
		lpszClassName = self.ClassName;
		hIconSm = nil;
		})

	self.Registration = user32.RegisterClassExA(aClass)

	assert(self.Registration ~= 0, "Registration error"..tostring(C.GetLastError()))
end



function GameWindow:CreateWindow(params)
	self.ClassName = params.ClassName
	self.Title = params.Title
	self.Width = params.Extent[1]
	self.Height = params.Extent[2]

	local dwExStyle = bit.bor(C.WS_EX_APPWINDOW, C.WS_EX_WINDOWEDGE)
	local dwStyle = bit.bor(C.WS_SYSMENU, C.WS_VISIBLE, C.WS_POPUP)

print("GameWindow:CreateWindow - 1.0")
	local hwnd = user32.CreateWindowExA(
		0,
		self.ClassName,
		self.Title,
		C.WS_OVERLAPPEDWINDOW,
		C.CW_USEDEFAULT,
		C.CW_USEDEFAULT,
		params.Extent[1], params.Extent[2],
		nil,
		nil,
		self.AppInstance,
		nil)
print("GameWindow:CreateWindow - 2.0")

	assert(hwnd,"unable to create window"..tostring(C.GetLastError()))


	self:OnCreated(hwnd)
end


function GameWindow:Show()
	user32.ShowWindow(self.WindowHandle, C.SW_SHOW)
end

function GameWindow:Hide()
end

function GameWindow:Update()
	user32.UpdateWindow(self.WindowHandle)
end


function GameWindow:SwapBuffers()
	gdi32.SwapBuffers(self.GDIContext.Handle);
end

function GameWindow:CreateGLContext()
	opengl32.wglMakeCurrent(nil, nil)

	self.GLContext = CreateGLContextFromWindow(self.WindowHandle, C.PFD_DOUBLEBUFFER)
	self.GLContext:Attach()

	print("GameWindow:CreateGLContext - GL Device Context: ", self.GLContext)

end

function GameWindow:OnCreated(hwnd)
print("GameWindow:OnCreated")

	local winptr = ffi.cast("intptr_t", hwnd)
	local winnum = tonumber(winptr)

	self.WindowHandle = hwnd
	GameWindow.WindowMap[winnum] = self

	local hdc = C.GetDC(self.WindowHandle)


	self.GDIContext = GDIContext(hdc)
	self.GDIContext:UseDCPen()
	self.GDIContext:UseDCBrush()

	self:CreateGLContext()

	self.IsValid = true
end

function GameWindow:OnDestroy()
	print("GameWindow:OnDestroy")

	C.PostQuitMessage(0)

	return 0
end

function GameWindow:OnQuit()
print("GameWindow:OnQuit")
	self.IsRunning = false

	-- delete glcontext
	if self.GLContext then
		self.GLContext:Destroy()
	end
end

function GameWindow:OnTick(tickCount)
	if (self.OnTickDelegate) then
		self.OnTickDelegate(self, tickCount)
	end
end

function GameWindow:OnFocusMessage(msg)
print("OnFocusMessage")
	if (self.OnSetFocusDelegate) then
		self.OnSetFocusDelegate(self, msg)
	end
end

function GameWindow:OnKeyboardMessage(msg)
	if self.KeyboardInteractor then
		self.KeyboardInteractor(msg)
	end
end

function GameWindow:OnMouseMessage(msg)
	if self.MouseInteractor then
		self.MouseInteractor(msg)
	end
end

--[[
	for window creation, we should see the
	following sequence
        WM_GETMINMAXINFO 		= 0x0024
        WM_NCCREATE 			= 0x0081
        WM_NCCALCSIZE 			= 0x0083
        WM_CREATE 				= 0x0001

	Then, after ShowWindow is called
		WM_SHOWWINDOW 			= 0x0018,
		WM_WINDOWPOSCHANGING 	= 0x0046,
		WM_ACTIVATEAPP 			= 0x001C,

	Closing Sequence
		WM_CLOSE 				= 0x0010,
		...
		WM_ACTIVATEAPP 			= 0x001C,
		WM_KILLFOCUS			= 0x0008,
		WM_IME_SETCONTEXT 		= 0x0281,
		WM_IME_NOTIFY 			= 0x0282,
		WM_DESTROY 				= 0x0002,
		WM_NCDESTROY 			= 0x0082,
--]]

function WindowProc(hwnd, msg, wparam, lparam)
-- lookup which window object is associated with the
-- window handle
	local winptr = ffi.cast("intptr_t", hwnd)
	local winnum = tonumber(winptr)

	local self = GameWindow.WindowMap[winnum]

--print(string.format("WindowProc: 0x%x, Window: 0x%x, self: %s", msg, winnum, tostring(self)))

	-- if we have a self, then the window is capable
	-- of handling the message
	if self then
		if (self.MessageDelegate) then
			result = self.MessageDelegate(hwnd, msg, wparam, lparam)
			return result
		end

		if (msg == C.WM_DESTROY) then
			return self:OnDestroy()
		end

		if (msg >= C.WM_MOUSEFIRST and msg <= C.WM_MOUSELAST) or
				(msg >= C.WM_NCMOUSEMOVE and msg <= C.WM_NCMBUTTONDBLCLK) then
				self:OnMouseMessage(msg, wparam, lparam)
		end

		if (msg >= C.WM_KEYDOWN and msg <= C.WM_SYSCOMMAND) then
				self:OnKeyboardMessage(msg, wparam, lparam)
		end
	end

	-- otherwise, it's not associated with a window that we know
	-- so do default processing
	return user32.DefWindowProcA(hwnd, msg, wparam, lparam);

end

-- The following 'jit.off(Loop)' is here because LuaJit
-- can't quite fix-up the case where a callback is being
-- called from LuaJit'd code
-- http://lua-users.org/lists/lua-l/2011-12/msg00712.html
--
-- I found the proper way to do this is to put the jit.off
-- call before the function body.
--
jit.off(Loop)
function Loop(win)
	local timerEvent = C.CreateEventA(nil, false, false, nil)
	-- If the timer event was not created
	-- just return
	if timerEvent == nil then
		error("unable to create timer")
		return
	end

	local handleCount = 1
	local handles = ffi.new('void*[1]', {timerEvent})

	local msg = ffi.new("MSG")
	local sw = StopWatch()
	local tickCount = 1
	local timeleft = 0
	local lastTime = sw:Milliseconds()
	local nextTime = lastTime + win.Interval * 1000

	local dwFlags = bor(C.MWMO_ALERTABLE,C.MWMO_INPUTAVAILABLE)

	while (win.IsRunning) do
		while (user32.PeekMessageA(msg, nil, 0, 0, C.PM_REMOVE) ~= 0) do
			user32.TranslateMessage(msg)
			user32.DispatchMessageA(msg)

--print(string.format("Loop Message: 0x%x", msg.message))

			if msg.message == C.WM_QUIT then
				return win:OnQuit()
			end

		end

		timeleft = nextTime - sw:Milliseconds();
		if (timeleft <= 0) then
			win:OnTick(tickCount);
			tickCount = tickCount + 1
			nextTime = nextTime + win.Interval * 1000
			timeleft = nextTime - sw:Milliseconds();
		end

		if timeleft < 0 then timeleft = 0 end

		-- use an alertable wait
		C.MsgWaitForMultipleObjectsEx(handleCount, handles, timeleft, C.QS_ALLEVENTS, dwFlags)
	end
end

function GameWindow:Run()
	if not self.IsValid then
		print('Window Handle is NULL')
		return
	end

	self.IsRunning = true

	self:Show()
	self:Update()

	Loop(self)
end



