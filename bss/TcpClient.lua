require "BanateCore"

require "SocketUtils"

class.TcpClient()

function TcpClient:_init(hostname, port)
	self.Socket = CreateTcpSocket("www.google.com", 80)
end

function TcpClient:Connect()
	self.Socket:Connect()
end

function TcpClient:Write(buff, len)
end

function TcpClient:Read(buff, len)
end



