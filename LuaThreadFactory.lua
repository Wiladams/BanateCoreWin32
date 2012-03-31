require "BanateCore"

require "win_kernel32"
require "win_user32"

local kernel32 = ffi.load("kernel32")
local user32 = ffi.load("user32")


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


function RunLuaThread(codechunk)
-- create lua state
-- load initial lua code, which can
-- be found in the param
end


class.LuaThreadFactory()

function LuaThreadFactory:_init()
end

function LuaThreadFactory:CreateThread()
end

function LuaThreadFactory:Run()
end
