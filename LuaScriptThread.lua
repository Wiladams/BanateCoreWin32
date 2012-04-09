require "BanateCore"

require "win_kernel32"

local kernel32 = ffi.load("kernel32")
local lua = ffi.load("lua51")

-- Definition of RunLuaThread
ffi.cdef[[
int RunLuaThread(void *s);
]]

--
-- This helper routine will take a pointer
-- to cdata, and return a string that contains
-- the memory address
function CreatePointerString(instance)
	if ffi.abi("64bit") then
		return string.format("0x%016x", tonumber(ffi.cast("int64_t", ffi.cast("void *", instance))))
	elseif ffi.abi("32bit") then
		return string.format("0x%08x", tonumber(ffi.cast("int32_t", ffi.cast("void *", instance))))
	end

	return nil
end


function PrependThreadParam(codechunk, threadparam)
	if threadparam == nil or codechunk == nil then return codechunk end

	local paramAsString = CreatePointerString(threadparam)

	return string.format("local _ThreadParam = %s\n\n%s", paramAsString, codechunk)
end



class.LuaScriptThread()

function LuaScriptThread:_init(codechunk, param, createSuspended)
	createSuspended = createSuspended or false
	local flags = 0
	if createSuspended then
		flags = CREATE_SUSPENDED
	end

	param = param or nil

	self.CodeChunk = codechunk
	self.ThreadParam = param
	self.Flags = flags

	-- prepend the param to the code chunk if it was supplied
	local threadprogram = PrependThreadParam(codechunk, param)
	local threadId = ffi.new("DWORD[1]")
	self.Handle = kernel32.CreateThread(nil,
		0,
		lua.RunLuaThread,
		ffi.cast("void *", threadprogram),
		flags,
		threadId)
	threadId = threadId[0]
	self.ThreadId = threadId
end

function LuaScriptThread:Resume()
-- need the following thread access right
--THREAD_SUSPEND_RESUME

	local result = kernel32.ResumeThread(self.Handle)
end

function LuaScriptThread:Suspend()
end

function LuaScriptThread:Yield()
	local result = kernel32.SwitchToThread()
end
