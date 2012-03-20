ffi = require "ffi"

function DefaultAppWindowProc(hwnd, msg, wparam, lparam)
	if (msg == C.WM_DESTROY) then
	print("WM_DESTROY")
			return self:OnDestroy()
		end
	end

	-- otherwise, it's not associated with a window that we know
	-- so do default processing
	return user32.DefWindowProcA(hwnd, msg, wparam, lparam);
end


--[[

	elseif msg == C.WM_NCCREATE then

		print("WM_NCCREATE")
		crstruct.lpCreateParams -- lparam from CreateWindowExA
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
