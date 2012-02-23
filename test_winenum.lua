
local ffi = require("ffi")
require "win_user32"

local C = ffi.C
local buf = ffi.new("char[?]", 256)
local lbuf = ffi.cast("intptr_t", buf)

function printTitle(hwnd, l)
	if C.SendMessageA(hwnd, C.WM_GETTEXT, 255, lbuf) ~= 0 then
		io.write(ffi.string(buf), "\n")
	end	
	return true
end

C.EnumWindows(printTitle, 0)

