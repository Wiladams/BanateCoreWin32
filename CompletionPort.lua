require "BanateCore"

require "win_kernel32"
local kernel32 = ffi.load("kernel32")

ffi.cdef[[
typedef struct {
	HANDLE	Handle;
} IOCompletionPort, *PIoCompletionPort;
]]
IOCompletionPort = ffi.typeof("IOCompletionPort")


class.CompletionPort()

function CompletionPort:_init(nThreads)
	nThreads = nThreads or 0
	self.ConcurrentThreads = nThreads

	-- Create the port
	self.Handle = kernel32:CreateIoCompletionPort(INVALID_HANDLE_VALUE, nil, nil, nThreads)

	self.CompletionThreads = {}
	self.CompletionPortHandles = {}
end

function CompletionPort:AddCompletionThread(newthread)

	local handle = kernel32:CreateIoCompletionPort(newthread.Handle,
		self.Handle,
		newthread.Key,
		0)

	-- Associate the completion port handle with
	-- the thread
	self.CompletionPortHandles[handle] = newthread
	self.CompletionThreads[newthread] = handle


end
