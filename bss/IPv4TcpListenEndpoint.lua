local ppath = package.path..';..\\?.lua;'
package.path = ppath;

require "BanateCore"
require "win_socket"

local wsock = ffi.load("ws2_32")

class.IPv4TcpListenEndpoint()

function IPv4TcpListenEndpoint:_init(port, delaylisten)
	delaylisten = delaylisten or false

	self.InternetAddr = ffi.new("SOCKADDR_IN");

	self.InternetAddr.sin_family = AF_INET;
	self.InternetAddr.sin_addr.S_un.S_addr = htonl(INADDR_ANY);
	self.InternetAddr.sin_port = htons(port);

	self.Socket = wsock.WSASocket(AF_INET, SOCK_STREAM, 0, nil, 0, WSA_FLAG_OVERLAPPED);

	wsock.bind(self.Socket, InternetAddr, ffi.sizeof("SOCKADDR_IN"))

	-- If we don't want to delay the start of listening
	-- then begin listening right away
	if not delaylisten then
		self:StartListening()
	end
end

function IPv4TcpListenEndpoint:StartListening(backlog)
	backlog = backlog or 5

--	wsock.listen(self.Socket, MAX_CONN)
	wsock.listen(self.Socket, backlog)
end
