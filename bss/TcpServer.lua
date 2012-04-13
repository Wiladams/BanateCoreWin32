-- Put this at the top of any test
local ppath = package.path..';..\\?.lua'
package.path = ppath;

require "BanateCore"
require "TcpSocket"

class.TcpServer()

function TcpServer:_init(hostname, port)
	port = port or daytimeport

	self.Socket = CreateTcpSocket()
	self.Socket:BindToPort(port)
	self.Socket:StartListening(5)
end

function TcpServer:OnAccept(acceptedsock)
print("TcpServer: OnAccept")

	-- Get the current date copied into a buffer
	local dt = os.date("%c")
	local dtlen = string.len(dt)
	memcpy(buff, dt, dtlen)
	buff[dtlen] = 0

	-- Write the buffer to the client
	acceptedsock:Write(buff, dtlen)


	-- close down the socket
	acceptedsock:Close()
end

function TcpServer:Run()
	local buff = ffi.new("char [256]")
	local bufflen = 256

print("Tcp Server Running")

	while (true) do
		local acceptedsock = self.Socket:Accept()

		self:OnAccept(acceptedsock)
	end
end
