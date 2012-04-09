local ppath = package.path..';..\\?.lua;'
package.path = ppath;

require "BanateCore"
require "win_socket"
require "SocketUtils"

local wsock = ffi.load("ws2_32")

ffi.cdef[[
typedef struct {
	ADDRESS_FAMILY	Family;
	uint16_t		Port;
	SOCKET			Socket;
} UDP_SOCKET;
]]

UDP_SOCKET = nil
UDP_SOCKET_mt = {
	__index = {
		BindToPort = function(self, port)
			inetaddr = ffi.new("SOCKADDR_IN");
			inetaddr.sin_family = AF_INET;
			inetaddr.sin_addr.s_addr = wsock.htonl(INADDR_ANY);
			inetaddr.sin_port = wsock.htons(port);

			wsock.bind(self.Socket, ffi.cast("struct sockaddr *",inetaddr), ffi.sizeof("SOCKADDR_IN"))
		end,

		Close = function(self)
			wsock.closesocket(self.Socket)
		end,

		Connect = function(self)
			wsock.connect(self.Socket)
		end,

		StartListening = function(self, backlog)
			backlog = backlog or 5

			wsock.listen(self.Socket, backlog)
			self.Listening = true
		end,

		Read = function(self, blob)
			local result = wsock.recv(self.Socket, blob.Data, blob.Length, 0);
		end,

		Write = function(self, blob)
			local result = wsock.send(self.Socket, blob.Data, blob.Length, 0);
		end,


	},
}
UDP_SOCKET = ffi.metatype("UDP_SOCKET", UDP_SOCKET_mt)


function CreateUdpSocket()
	local holder = UDP_SOCKET()

	local socket = wsock.WSASocketA(AF_INET, SOCK_DGRAM, 0, nil, 0, WSA_FLAG_OVERLAPPED);

	holder:SetSocket(socket)
	holder:SetPort(port)

	local sockstruct = UDP_SOCKET(AF_INET, port, socket)

	return sockstruct
end


