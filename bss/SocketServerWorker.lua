-- Put this at the top of any test
local ppath = package.path..';..\\?.lua;'
package.path = ppath;

require "BanateCore"
require "win_socket"
require "Heap"
require "IPv4TcpListenEndpoint"

local wsock = ffi.load("ws2_32")
local kernel32 = ffi.load("kernel32")

local CompletionPort = ffi.cast("HANDLE", _ThreadParam);

--
-- This is the code that is run for each IOCompletion
-- port worker thread.  It is responsible for waiting
-- for work on the completion port


local lpNumberOfBytesTransferred = ffi.typeof("unsigned int*[1]");
local lpCompletionKey = ffi.typeof("PULONG_PTR[1]");
local lpOverlapped = ffi.typeof("LPOVERLAPPED[1]");

local BytesTransferred
local PerHandleData;
local PerIoData;

local SendBytes=0
local RecvBytes = 0;
local Flags = 0;

while(true) do
	if (kernel32.GetQueuedCompletionStatus(CompletionPort, lpNumberOfBytesTransferred,
		lpCompletionKey, lpOverlapped, INFINITE) == 0) then
			print(string.format("GetQueuedCompletionStatus() failed with error %d\n", GetLastError()));
		return 0;
	else
		BytesTransferred = lpNumberOfBytesTransferred[0];
		PerHandleData = lpCompletionKey[0];
		PerIoData = lpOverlapped[0];

		print(string.format("GetQueuedCompletionStatus() is OK!\n"));
	end

	-- First check to see if an error has occurred on the socket and if so
	-- then close the socket and cleanup the SOCKET_INFORMATION structure
	-- associated with the socket
	if (BytesTransferred ~= 0) then
		-- Check to see if the BytesRECV field equals zero. If this is so, then
		-- this means a WSARecv call just completed so update the BytesRECV field
		-- with the BytesTransferred value from the completed WSARecv() call
		if (PerIoData.BytesRECV == 0) then
			PerIoData.BytesRECV = BytesTransferred;
			PerIoData.BytesSEND = 0;
		else
			PerIoData.BytesSEND = PerIoData.BytesSEND + BytesTransferred;
		end

		if (PerIoData.BytesRECV > PerIoData.BytesSEND) then
			-- Post another WSASend() request.
			-- Since WSASend() is not guaranteed to send all of the bytes requested,
			-- continue posting WSASend() calls until all received bytes are sent.
			ffi.fill(PerIoData.Overlapped, ffi.sizeof("OVERLAPPED"));
			PerIoData.DataBuf.buf = PerIoData.Buffer + PerIoData.BytesSEND;
			PerIoData.DataBuf.len = PerIoData.BytesRECV - PerIoData.BytesSEND;
			if (wsock.WSASend(PerHandleData.Socket, PerIoData.DataBuf, 1, SendBytes, 0,
				PerIoData.Overlapped, nil) == SOCKET_ERROR) then
				if (wsock.WSAGetLastError() ~= ERROR_IO_PENDING) then
					print(string.format("WSASend() failed with error %d\n", wsock.WSAGetLastError()));
					return 0;
				end
			else
				print("WSASend() is OK!\n");
			end
		else
			PerIoData.BytesRECV = 0;
			-- Now that there are no more bytes to send post another WSARecv() request
			Flags = 0;
			ffi.fill(PerIoData.Overlapped, ffi.sizeof("OVERLAPPED"));
			PerIoData.DataBuf.len = DATA_BUFSIZE;
			PerIoData.DataBuf.buf = PerIoData.Buffer;

			if (wsock.WSARecv(PerHandleData.Socket, PerIoData.DataBuf, 1, RecvBytes, Flags,
				PerIoData.Overlapped, nil) == SOCKET_ERROR) then
				if (wsock.WSAGetLastError() ~= ERROR_IO_PENDING) then
					print(string.format("WSARecv() failed with error %d\n", wsock.WSAGetLastError()));
					return 0;
				end
			else
				print("WSARecv() is OK!\n");
			end
		end
	else
		-- reference: http://xania.org/200807/iocp
		-- Bytes read was zero, so close things down
		print(string.format("Closing socket %d\n", PerHandleData.Socket));
		if (closesocket(PerHandleData.Socket) == SOCKET_ERROR) then
			print(string.format("closesocket() failed with error %d\n", wsock.WSAGetLastError()));
			return 0;
		else
			print("closesocket() is fine!\n");
		end

		PerHandleData = nil
		PerIoData = nil
	end
end
