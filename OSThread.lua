require "BanateCore"

require "win_kernel32"

local kernel32 = ffi.load("kernel32")


class.OSThread()

function OSThread:_init(threadRoutine, param, flags)
	flags = flags or 0
	param = param or nil

	self.ThreadRoutine = threadRoutine
	self.Parameter = param
	self.Flags = flags

	local threadId = ffi.new("DWORD[1]")
	self.Handle = kernel32.CreateThread(nil,
		0,
		self.ThreadRoutine,
		self.Parameter,
		flags,
		threadId)
	threadId = threadId[0]
	self.ThreadId = threadId
end


