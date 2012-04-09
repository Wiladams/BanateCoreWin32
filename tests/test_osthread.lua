-- test_winsock.lua
-- Put this at the top of any test
local ppath = package.path..';..\\?.lua'
package.path = ppath;

require "LuaScriptThread"
require "LuaState"
require "win_user32"
require "WinBase"

local user32 = ffi.load("user32")





handles = ffi.new("HANDLE[2]")

ffi.cdef("typedef struct {int Data;}buffer;")


local code1 = [[
	ffi = require "ffi"

	ffi.cdef("typedef struct {int Data;}buffer;")

	print("thread code 1")
	local voidptr = ffi.cast("void *", _ThreadParam)
	local buff = ffi.cast("buffer *", voidptr)

	print("Buffer Data: ", buff.Data)
]]

local code2 = [[
	print("thread code 2")
]]




-- Create a couple of threads
local buff1 = ffi.new("buffer[1]")
buff1[0].Data = 5

thread1 = LuaScriptThread(code1, buff1)
thread2 = LuaScriptThread(code2, nil, true)

handles[0] = thread1.Handle
handles[1] = thread2.Handle

-- Wait until the threads terminate
thread2:Resume()

user32.MsgWaitForMultipleObjects(2, handles, true, 500)

	print("Threads 1: ", thread1.Handle, thread1.ThreadId)
	print("Threads 2: ", thread2.Handle, thread2.ThreadId)



