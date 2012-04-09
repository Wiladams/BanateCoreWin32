require "TcpSocket"
require "win_socket"
require "SocketUtils"

local wsock = ffi.load("ws2_32")

local echoPort = 500

--local sock1 = CreateTcpSocket()
--sock1:BindToPort(echoPort)

--sock1:StartListening()

--local addr = ffi.new("struct in_addr[1]")
--error = wsock.inet_pton(AF_INET, "74.125.127.147", addr);
--addr = addr[0]

--print(addr.s_addr)

--print(ffi.string(wsock.inet_ntoa(addr)))

--print("sockaddr_in size: ", ffi.sizeof("struct sockaddr_in"))
--print("Size Of IN6_ADDR: ", ffi.sizeof("struct in6_addr"))
--print("sockaddr_in6 size: ", ffi.sizeof("struct sockaddr_in6"))
--print("sockaddr_storage size: ", ffi.sizeof("struct sockaddr_storage"))

function test_IPV4Address()
	local a1 = IN_ADDR()
--	print("A1 Default: ", a1)

--	a1:SetFromString("74.125.127.147")
--	print("A1 After Set: ", a1)

	local sa1 = CreateIPV4Address("74.125.127.147", 80)
--	print("IPV4 Address: ", sa1:GetAddress())
	print("sa1: ", sa1)
end


function test_IPV6Address()
	local sa2 = CreateIPV6Address("2001:db8:8714:3a90::12", 120)
--local sa2 = SOCKADDR_STORAGE(AF_INET6)
--sa2:SetPort(120)
--sa2:SetAddress("2001:db8:8714:3a90::12")
	print("IPV6 Address: ", sa2:GetAddress())
	print("sa2: ", sa2)
end

ffi.cdef[[
typedef struct inner {
	int data;
} inner;

typedef struct outer {
	int foo;
	inner bar;
} outer;
]]

function test_Assignment()

	local out = ffi.new("outer")
	local inner = ffi.new("inner")
	inner.data = 5

	out.bar = inner

	print("out.bar: ", out.bar.data)

end


test_IPV4Address()

--test_IPV6Address()

--test_Assignment()
