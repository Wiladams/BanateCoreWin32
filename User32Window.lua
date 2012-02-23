--
-- User32Window.lua
--
local bit = require "bit"
local ffi = require "ffi"
local C = ffi.C

local class = require "class"

require "win_user32"
require "win_kernel32"

local user32 = ffi.load("User32")
local kernel32 = ffi.load("Kernel32")


class.User32Window()

User32Window.Defaults = {
	ClassName = "LuaWindow",
	Title = "Application",
	Origin = {10,10},
	Extent = {320, 240},
}

function User32Window:_init(params)
	params = params or User32Window.Defaults

	params.ClassName = params.ClassName or User32Window.Defaults.ClassName
	params.Title = params.Title or User32Window.Defaults.Title
	params.Origin = params.Origin or User32Window.Defaults.Origin
	params.Extent = params.Extent or User32Window.Defaults.Extent

	self.Registration = nil
	self.IsReady = false
	self.IsValid = false

	self:Register(params)
	self:CreateWindow(params)
end



--[[
	for window creation, we should see the
	following sequence
        WM_GETMINMAXINFO = 0x0024
        WM_NCCREATE = 0x0081
        WM_NCCALCSIZE = 0x0083
        WM_CREATE = 0x0001

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

function User32Window.WindowProc(hwnd, msg, wparam, lparam)
print(string.format("message: 0x%x", msg))

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
		--return 0
		return user32.DefWindowProcA(hwnd, msg, wparam, lparam)
	end


	local retValue = user32.DefWindowProcA(hwnd, msg, wparam, lparam)

	return retValue;
end


function User32Window:Register(params)
	self.AppInstance = kernel32.GetModuleHandleA(nil)
	self.ClassName = params.ClassName

	local classStyle = bit.bor(C.CS_HREDRAW, C.CS_VREDRAW, C.CS_OWNDC);
	--local classStyle = 0

	local aClass = ffi.new('WNDCLASSEXA', {
		cbSize = ffi.sizeof("WNDCLASSEXA");
		style = classStyle;
		lpfnWndProc = User32Window.WindowProc;
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



function User32Window:CreateWindow(params)
	self.ClassName = params.ClassName
	self.Title = params.Title

	local dwExStyle = bit.bor(C.WS_EX_APPWINDOW, C.WS_EX_WINDOWEDGE)
	local dwStyle = bit.bor(C.WS_SYSMENU, C.WS_VISIBLE, C.WS_POPUP)


	self.Handle = user32.CreateWindowExA(
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

	if self.Handle == nil then
		print('unable to create window')
		print("Error: ", C.GetLastError())
	else
		self.IsValid = true
	end
end

function User32Window:Show()
	user32.ShowWindow(self.Handle, C.SW_SHOW)
end

function User32Window:Hide()
end

function User32Window:Update()
	user32.UpdateWindow(self.Handle)
end
