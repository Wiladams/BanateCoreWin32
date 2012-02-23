--
-- User32Window.lua
--
local bit = require "bit"
local ffi = require "ffi"
local C = ffi.C

require "win_user32"
require "win_kernel32"

local user32 = ffi.load("User32")
local kernel32 = ffi.load("Kernel32")

local AppInstance = kernel32.GetModuleHandleA(nil)
local ClassName = "LuaWindow"




function WindowProc(hwnd, msg, wparam, lparam)
print(string.format("message: 0x%x", msg))

	if msg == C.WM_GETMINMAXINFO then
--[[
		local sizeinfo = ffi.cast("PMINMAXINFO", lparam)
		print("WM_GETMINMAXINFO")
		print(string.format("Reserved: %d %d", sizeinfo.ptReserved.x, sizeinfo.ptReserved.y))
		print(string.format("MaxSize: %d %d", sizeinfo.ptMaxSize.x, sizeinfo.ptMaxSize.y))
		print(string.format("MaxPosition: %d %d", sizeinfo.ptMaxPosition.x, sizeinfo.ptMaxPosition.y))
		print(string.format("MinTrackSize: %d %d", sizeinfo.ptMinTrackSize.x, sizeinfo.ptMinTrackSize.y))
--]]
		return 0
	elseif msg == C.WM_NCCREATE then
--[[
		print("WM_NCCREATE")
		local crstruct = ffi.cast("LPCREATESTRUCTA", lparam)
		print("  Class: ", ffi.string(crstruct.lpszClass))
		print("  Title: ", ffi.string(crstruct.lpszName))
		print(string.format("  ExStyle: 0x%x", crstruct.dwExStyle))
		print(string.format("  Style: 0x%x", crstruct.style))
		print(string.format("  X: %d  Y: %d", crstruct.x, crstruct.y))
		print(string.format("  W: %d  H: %d", crstruct.cx, crstruct.cy))
--]]
		return 1
	elseif (msg == C.WM_DESTROY) then
		print("WM_DESTROY")
		C.PostQuitMessage(0)
		return 0
	end

	--return user32.DefWindowProcA(hwnd, msg, wparam, lparam)

	local retValue = user32.DefWindowProcA(hwnd, msg, wparam, lparam)

	return retValue;
end


local classStyle = 0

local aClass = ffi.new('WNDCLASSEXA', {
		cbSize = ffi.sizeof("WNDCLASSEXA");
		style = bit.bor(C.CS_HREDRAW, C.CS_VREDRAW);
		lpfnWndProc = WindowProc;
		cbClsExtra = 0;
		cbWndExtra = 0;
		hInstance = AppInstance;
		hIcon = nil;
		hCursor = nil;
		hbrBackground = nil;
		lpszMenuName = nil;
		lpszClassName = ClassName;
		hIconSm = nil;
		})

local registration = user32.RegisterClassExA(aClass)

print("Registration: ", registration)


if (registration == 0) then
	registration = nil
	print("Registration error")
	print(C.GetLastError())
else
	print("Successful Registration:", registration)
end


local dwExStyle = bit.bor(C.WS_EX_APPWINDOW, C.WS_EX_WINDOWEDGE)
local dwStyle = bit.bor(C.WS_SYSMENU, C.WS_VISIBLE, C.WS_POPUP)

local winHandle = user32.CreateWindowExA(
		0,
		ClassName,
		"Window Title",
		C.WS_OVERLAPPEDWINDOW,
		C.CW_USEDEFAULT,
		C.CW_USEDEFAULT,
		320, 240,
		nil,
		nil,
		AppInstance,
		nil)

local isValid = false

if winHandle == nil then
	print('unable to create window')
	print("Error: ", C.GetLastError())
else
	isValid = true
end


--[[

user32.ShowWindow(self.Handle, C.SW_SHOW)

user32.UpdateWindow(self.Handle)



local msg = ffi.new("MSG")

local quitting = false

while(user32.GetMessage(msg, nil, 0, 0) > 0) do
	user32.TranslateMessage(msg)
	user32.DispatchMessageA(msg)
end


print(win.Title)
--]]
