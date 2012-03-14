require "User32Window"

local ffi = require "ffi"
require "win_user32"
require "User32Window"

local user32 = ffi.load("User32")

function main()
	win = User32Window({Title = "Super Lua Window"})
--	win = User32Window()
	if not win.IsValid then
		print('Window Handle is NULL')
		return
	end

	win:Show()
	win:Update()

	local msg = ffi.new("MSG")

	while(user32.GetMessageA(msg, nil, 0, 0) > 0) do
		user32.TranslateMessage(msg)
		user32.DispatchMessageA(msg)
	end
end

main()


