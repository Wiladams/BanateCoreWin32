-- Put this at the top of any test
local ppath = package.path..';..\\?.lua'
package.path = ppath;

require "BanateCore"
require "TcpSocket"

class.DaytimeClient()

local daytimeport = 13

function DaytimeClient:_init(hostname, port)
	hostname = hostname or "localhost"
	port = port or daytimeport

	self.Socket = CreateTcpClientSocket(hostname, port)
	self.Socket:Connect()
end

function DaytimeClient:Run()
	local buff = ffi.new("char [256]")
	local bufflen = 256

	n = self.Socket:Read(buff, bufflen)
	while (n > 0) do
		buff[n] = 0		-- null terminated
		print(ffi.string(buff))

		n = self.Socket:Read(buff, bufflen)
	end

	if (n<0) then
		print("Error Reading")
	end

	return 0
end
