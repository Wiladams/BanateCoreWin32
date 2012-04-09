require "BanateCore"

-- This is a template
-- In order to create a functor:
-- 1) Copy this code
-- 2) Change the Moniker: 'Functor' to the name of
--		Whatever functor is being created
-- 3) Implement the specific code in the Execute() function
--


ffi.cdef[[
typedef struct _LISTEN_OBJ
{
    SOCKET          s;
    int             AddressFamily;
/*
    BUFFER_OBJ     *PendingAccepts; // Pending AcceptEx buffers
    volatile long   PendingAcceptCount;

    int             HiWaterMark, LoWaterMark;
    HANDLE          AcceptEvent;
    HANDLE          RepostAccept;
    volatile long   RepostCount;

    // Pointers to Microsoft specific extensions.
    LPFN_ACCEPTEX             lpfnAcceptEx;
    LPFN_GETACCEPTEXSOCKADDRS lpfnGetAcceptExSockaddrs;
    CRITICAL_SECTION ListenCritSec;
    struct _LISTEN_OBJ *next;
*/
} LISTEN_OBJ;
]]


CreateAsyncSocketListener={}
CreateAsyncSocketListener_mt = {}

function CreateAsyncSocketListener.new(ipaddress, port)
	local self = {}

	setmetatable(self, CreateAsyncSocketListener_mt)

	self.IPAddress = ipaddress
	self.Port = port

	return self
end

function CreateAsyncSocketListener.Execute(self, ...)
	print ("Functor.Execute")
end

CreateAsyncSocketListener_mt.__call = CreateAsyncSocketListener.Execute;


--[[
local aCommand = Functor.new("this")

aCommand()
--]]


