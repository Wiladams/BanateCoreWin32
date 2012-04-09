-- Put this at the top of any test
local ppath = package.path..';..\\?.lua'
package.path = ppath;

require "BanateCore"
require "win_socket"
require "SocketUtils"
require "TcpSocket"

local wsock = ffi.load("ws2_32")

local function printAddressInfo(info)
	print(" ==== AddressInfo ====")
	--print("Flags: ", info.ai_flags)
	print(info)
	print("Name: ", info.ai_canonname)
	--print("Next: ", info.ai_next)

	if info.ai_next ~= nil then
		printAddressInfo(info.ai_next)
	end
end

function test_SocketAddress()
	local addr = CreateSocketAddress("www.google.com", 80)
--local addr = CreateIPV6Address("2001:0db8:85a3:0000:0000:8a2e:0370:7334", 80)
--local addr = GetSocketAddress("192.168.1.101", 80)  -- beaglebone

	print("Address: ", addr)
	print("Size: ", addr:Size())
	print("Family: ", addr:Family())
end


function test_TcpSocket()
	local sock = CreateTcpSocket("www.google.com", 80)
	sock:Connect()
	sock:Close()
end


--test_SocketAddress()
test_TcpSocket()
