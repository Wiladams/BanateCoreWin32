-- Put this at the top of any test
local ppath = package.path..';..\\?.lua;..\\core\\?.lua;'
package.path = ppath;

require "BanateCore"
require "win_socket"
require "Heap"
require "IPv4TcpListenEndpoint"
require "AsyncAcceptor"
require "TcpSocket"


local wsock = ffi.load("ws2_32")

local heap = CreateHeap()

WSAOVERLAPPED = ffi.typeof("WSAOVERLAPPED")
SOCKET = ffi.typeof("SOCKET")
WSABUF = ffi.typeof("WSABUF")


PER_HANDLE_DATA = ffi.typeof("PER_HANDLE_DATA")


class.SocketServer()


function SocketServer:_init()
	self.DATA_BUFSIZE = 4096
	self.AcceptSocket = nil

	self.DataBuf = WSABUF()

	self.EventArray ffi.new("WSAEVENT", MAXIMUM_WAIT_OBJECTS) -- WSAEVENT

	self.Flags;
	self.RecvBytes;
	self.Index = ;

	self.buffer = ffi.new("char", self.DATA_BUFSIZE)



	self.Overlapped = WSAOVERLAPPED()

	-- Create a listening Socket
	-- And start listening (automatically)
	self.ListenSocket = CreateTcpSocket()
	self.ListenSocket:StartListening()


-- Step 3:
-- Now that we have an accepted socket, start
-- processing I/O using overlapped I/O with a
-- completion routines.  To get the overlapped I/O
-- processing started, first submit an
-- overlapped WSARecv() request.
	Flags = 0;

	ffi.Fill(Overlapped, ffi.sizeof(WSAOVERLAPPED))

	DataBuf.len = DATA_BUFSIZE;
	DataBuf.buf = buffer;

-- Step 4:
-- Post an asynchronous WSARecv() request
-- on the socket by specifying the WSAOVERLAPPED
-- structure as a parameter, and supply
-- the WorkerRoutine function below as the
-- completion routines
	if (WSARecv(AcceptSocket, DataBuf, 1, RecvBytes,
		Flags, Overlapped, WorkerRoutine) == SOCKET_ERROR) then
		if winsock2.WSAGetLastError() ~= WSA_IO_PENDING then
			print(string.format("WSARecv() failed with error %d\n", WSAGetLastError()))
			return ;
		end
	end


end




