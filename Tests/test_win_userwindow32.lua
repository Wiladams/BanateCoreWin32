-- test_win_userwindow32.lua

local ffi = require "ffi"
local C = ffi.C

require "win_user32"

local user32 = ffi.load("User32")

function msgProc(hwnd, msg, wparam, lparam)
--print(string.format("msgProc: 0x%x", msg))

	if (msg == C.WM_CREATE) then
		print("WM_CREATE")

		local crstruct = ffi.cast("LPCREATESTRUCTA", lparam)

		print(crstruct.lpCreateParams)
		local win = ffi.cast("PUser32Window", crstruct.lpCreateParams)
		win:OnCreate()
	end

	if (msg == C.WM_DESTROY) then
		C.PostQuitMessage(0)
		--return 0
		return user32.DefWindowProcA(hwnd, msg, wparam, lparam)
	end


	local retValue = user32.DefWindowProcA(hwnd, msg, wparam, lparam)

	return retValue;
end


--local uwin = User32WindowClass():new("testclass", msgProc)
local uwin = User32WindowClass():new("testclass")


local win = uwin:CreateWindow("User32 Window", 10, 10, 640, 480)

win:Show()
win:Update()

jit.off(main)
function main()

	local msg = ffi.new("MSG");

	while(C.GetMessageA(msg, nil, 0, 0) > 0) do
		C.TranslateMessage(msg);
		C.DispatchMessageA(msg);
	end

	return msg.wParam;
end

main()

