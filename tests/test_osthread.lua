-- test_winsock.lua
-- Put this at the top of any test
local ppath = package.path..';..\\?.lua'
package.path = ppath;

require "OSThread"
require "LuaState"
require "win_user32"
require "WinBase"

local user32 = ffi.load("user32")


ffi.cdef[[
int RunLuaThread(void *s);
]]

local lua = ffi.load("lua51")
--lua.RunLuaThread([[print("Hello, Lua!!")]])


handles = ffi.new("HANDLE[2]")


local code1 = [[
	print("thread code 1")
]]

local code2 = [[
	print("thread code 2")
]]




-- Create a couple of threads

thread1 = OSThread(lua.RunLuaThread, ffi.cast("void *", code1))
thread2 = OSThread(lua.RunLuaThread, ffi.cast("void *", code2))

handles[0] = thread1.Handle
handles[1] = thread2.Handle

-- Wait until the threads terminate

user32.MsgWaitForMultipleObjects(2, handles, true, 500)

	print("Threads 1: ", thread1.Handle, thread1.ThreadId)
	print("Threads 2: ", thread2.Handle, thread2.ThreadId)



