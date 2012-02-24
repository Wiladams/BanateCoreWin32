--
-- GameWindow.lua
--


local bit = require "bit"
local bor = bit.bor

local ffi = require "ffi"
local C = ffi.C

local class = require "class"

require "win_user32"
require "win_kernel32"
require "StopWatch"

local user32 = ffi.load("User32")
local kernel32 = ffi.load("Kernel32")


class.GameWindow()

GameWindow.Defaults = {
	ClassName = "LuaWindow",
	Title = "Application",
	Origin = {10,10},
	Extent = {320, 240},
	FrameRate = 20,
}

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
	self.KeyboardInteractor = params.KeyboardInteractor
	self.MouseInteractor = params.MouseInteractor
	self.GestureInteractor = params.GestureInteractor

	self:Register(params)
	self:CreateWindow(params)
end

function GameWindow:SetFrameRate(rate)
	self.FrameRate = rate
	self.Interval = 1/self.FrameRate
end


--[[
	for window creation, we should see the
	following sequence
        /// WM_GETMINMAXINFO = 0x0024
        /// WM_NCCREATE = 0x0081
        /// WM_NCCALCSIZE = 0x0083
        /// WM_CREATE = 0x0001

	Then, after ShowWindow is called
	WM_SHOWWINDOW = 0x0018,
	WM_WINDOWPOSCHANGING = 0x0046,
	WM_ACTIVATEAPP = 0x001C,

	Closing Sequence
		WM_CLOSE 			= 0x0010,
		...
		WM_ACTIVATEAPP 		= 0x001C,
		WM_KILLFOCUS		= 0x0008,
		WM_IME_SETCONTEXT = 0x0281,
		WM_IME_NOTIFY = 0x0282,
		WM_DESTROY 			= 0x0002,
		WM_NCDESTROY 		= 0x0082,
--]]

function GameWindow.WindowProc(hwnd, msg, wparam, lparam)
--print(string.format("message: 0x%x", msg))

--[[
	if msg == C.WM_GETMINMAXINFO then

		local sizeinfo = ffi.cast("PMINMAXINFO", lparam)
		print("WM_GETMINMAXINFO")
		print(string.format("Reserved: %d %d", sizeinfo.ptReserved.x, sizeinfo.ptReserved.y))
		print(string.format("MaxSize: %d %d", sizeinfo.ptMaxSize.x, sizeinfo.ptMaxSize.y))
		print(string.format("MaxPosition: %d %d", sizeinfo.ptMaxPosition.x, sizeinfo.ptMaxPosition.y))
		print(string.format("MinTrackSize: %d %d", sizeinfo.ptMinTrackSize.x, sizeinfo.ptMinTrackSize.y))

		return user32.DefWindowProcA(hwnd, msg, wparam, lparam)

	elseif msg == C.WM_NCCREATE then

		print("WM_NCCREATE")
		local crstruct = ffi.cast("LPCREATESTRUCTA", lparam)
		print("  Class: ", ffi.string(crstruct.lpszClass))
		print("  Title: ", ffi.string(crstruct.lpszName))
		print(string.format("  ExStyle: 0x%x", crstruct.dwExStyle))
		print(string.format("  Style: 0x%x", crstruct.style))
		print(string.format("  X: %d  Y: %d", crstruct.x, crstruct.y))
		print(string.format("  W: %d  H: %d", crstruct.cx, crstruct.cy))

		return user32.DefWindowProcA(hwnd, msg, wparam, lparam)
	end
--]]
	if (msg == C.WM_DESTROY) then
		C.PostQuitMessage(0)
		return 0
		--return user32.DefWindowProcA(hwnd, msg, wparam, lparam)
	end


	return user32.DefWindowProcA(hwnd, msg, wparam, lparam);
end



function GameWindow:Register(params)
	self.AppInstance = kernel32.GetModuleHandleA(nil)
	self.ClassName = params.ClassName

	local classStyle = bit.bor(C.CS_HREDRAW, C.CS_VREDRAW, C.CS_OWNDC);
	--local classStyle = 0

	local aClass = ffi.new('WNDCLASSEXA', {
		cbSize = ffi.sizeof("WNDCLASSEXA");
		style = classStyle;
		lpfnWndProc = GameWindow.WindowProc;
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

	if (self.Registration == 0) then
		self.Registration = nil
		print("Registration error")
		print(C.GetLastError())
	end
end



function GameWindow:CreateWindow(params)
	self.ClassName = params.ClassName
	self.Title = params.Title

	local dwExStyle = bit.bor(C.WS_EX_APPWINDOW, C.WS_EX_WINDOWEDGE)
	local dwStyle = bit.bor(C.WS_SYSMENU, C.WS_VISIBLE, C.WS_POPUP)


	self.WindowHandle = user32.CreateWindowExA(
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

	if self.WindowHandle == nil then
		print('unable to create window')
		print("Error: ", C.GetLastError())
	else
		self.IsValid = true
	end
end

function GameWindow:Show()
	user32.ShowWindow(self.WindowHandle, C.SW_SHOW)
end

function GameWindow:Hide()
end

function GameWindow:Update()
	user32.UpdateWindow(self.WindowHandle)
end

function GameWindow:OnTick(tickCount)
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

	while (win.IsRunning) do
		while (user32.PeekMessageA(msg, nil, 0, 0, C.PM_REMOVE) ~= 0) do
			user32.TranslateMessage(msg)
			user32.DispatchMessageA(msg)

			if msg.message == C.WM_QUIT then
				win.IsRunning = false
			end

			if (msg.message >= C.WM_MOUSEFIRST and msg.message <= C.WM_MOUSELAST) or
				(msg.message >= C.WM_NCMOUSEMOVE and msg.message <= C.WM_NCMBUTTONDBLCLK) then
				win:OnMouseMessage(msg)
			end

			if (msg.message >= C.WM_KEYDOWN and msg.message <= C.WM_SYSCOMMAND) then
				win:OnKeyboardMessage(msg)
			end
		end

		timeleft = nextTime - sw:Milliseconds();
		if (timeleft <= 0) then
			win:OnTick(tickCount);
			tickCount = tickCount + 1
			nextTime = nextTime + win.Interval * 1000
			timeleft = nextTime - sw:Milliseconds();
		end

		-- use an alertable wait
		local dwFlags = bor(C.MWMO_ALERTABLE,C.MWMO_INPUTAVAILABLE)
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



