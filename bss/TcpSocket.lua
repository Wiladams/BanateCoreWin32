local ppath = package.path..';..\\?.lua;'
package.path = ppath;

require "BanateCore"
require "win_socket"
require "SocketUtils"

local wsock = ffi.load("ws2_32")

ffi.cdef[[
typedef struct {
	SOCKADDR_STORAGE	*Address;
	SOCKET				Socket;
	bool				Listening;
} TCP_SOCKET;
]]

TCP_SOCKET = nil
TCP_SOCKET_mt = {
	__index = {
		BindToPort = function(self, port, family)
			family = family or AF_INET
			local addr = CreateIPV4WildcardAddress(family, port)
			local addrlen = ffi.sizeof("struct sockaddr_in")
			local err = wsock.bind(self.Socket, ffi.cast("struct sockaddr *",addr), addrlen)
		end,

		Close = function(self)
			wsock.closesocket(self.Socket)
		end,

		Accept = function(self)
--			local addr = ffi.new("struct sockaddr")
--			local Paddr = ffi.new("PSOCKADDR[1]", addr)
--			local intptr = ffi.new("int[1]")
--			local sock =  wsock.accept(self.Socket, Paddr,intptr);
			local sock =  wsock.accept(self.Socket, nil, nil);
			--local addrlen = intptr[0]

			local socket = TCP_SOCKET(nil, sock, false)
			return socket
		end,

		Connect = function(self)
			local addr = ffi.cast("struct sockaddr *", self.Address)
			local err = wsock.connect(self.Socket, addr, self.Address:Size());
			return err
		end,

		StartListening = function(self, backlog)
			backlog = backlog or 5

			wsock.listen(self.Socket, backlog)
			self.Listening = true
		end,

		Read = function(self, buff, bufflen)
			local result = wsock.recv(self.Socket, buff, bufflen, 0);
			return result
		end,

		Write = function(self, buff, bufflen)
			local result = wsock.send(self.Socket, buff, bufflen, 0);
			return result
		end,


	},
}
TCP_SOCKET = ffi.metatype("TCP_SOCKET", TCP_SOCKET_mt)

function CreateTcpSocket()
	local socket = wsock.WSASocketA(AF_INET, SOCK_STREAM, 0, nil, 0, WSA_FLAG_OVERLAPPED);

	local sockstruct = TCP_SOCKET(nil, socket, false)

	return sockstruct
end

function CreateTcpClientSocket(hostname, port)
	local addr = CreateSocketAddress(hostname, port)
	local fam, famstr = addr:Family()
print("CreateTcpSocket Family: ", fam, famstr)

--	local socket = wsock.WSASocketA(AF_INET, SOCK_STREAM, 0, nil, 0, WSA_FLAG_OVERLAPPED);
	local socket = wsock.WSASocketA(AF_INET, SOCK_STREAM, 0, nil, 0, 0);

	local sockstruct = TCP_SOCKET(addr, socket, false)

	return sockstruct
end


