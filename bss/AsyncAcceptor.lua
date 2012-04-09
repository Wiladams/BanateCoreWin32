-- Put this at the top of any test
local ppath = package.path..';..\\?.lua;'
package.path = ppath;

require "BanateCore"
require "win_socket"
require "Heap"
require "IPv4TcpListenEndpoint"

ffi.cdef[[
typedef struct _PER_HANDLE_DATA
{
	SOCKET        Socket;
	SOCKADDR_IN  ClientAddr;

	// Other information useful to be associated with the handle
} PER_HANDLE_DATA, * LPPER_HANDLE_DATA;
]]

class.ConnectionAcceptor()

function AsyncAcceptor:_init(completionport)
	self.CompletionPort = completionport

	self:Run()
end

function ConnectionAcceptor:Run()
	local ARemoteAddress = ffi.new("SOCKADDR_IN[1]")
	local ARemoteLen = ffi.new("INT[1]")
	local saRemoteLen = ffi.sizeof("SOCKADDR_IN")

	while (true) do
		local saRemoteLen = ffi.sizeof("SOCKADDR_IN")
		local saRemoteLenArray = ffi.new("INT[1]", saRemoteLen)

		-- Accept connection
		local acceptedSocket = wsock.WSAAccept(self.ListenEndpoint.Socket, ARemoteAddress, ARemoteLen, nil, nil);

		-- Create per connection data information to associate with
		-- the accepted socket
		local PerHandleData =  heap:Alloc(ffi.sizeof("PER_HANDLE_DATA"))
		PerHandleData.Socket = acceptedSocket

		self.CompletionPort:AddSocket(acceptedSocket, PerHandleData, 0)
	end
end
