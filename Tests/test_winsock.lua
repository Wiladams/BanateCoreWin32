-- test_winsock.lua
-- Put this at the top of any test
local ppath = package.path..';..\\?.lua;..\\core\\?.lua;'
package.path = ppath;

local ffi = require "ffi"
local C = ffi.C
local bit = require "bit"
local lshift = bit.lshift
local rshift = bit.rshift
local band = bit.band
local bor = bit.bor
local bswap = bit.bswap

local WinSock = require "win_socket"

local winsock2 = ffi.load("ws2_32")

print("win_socket.lua - TEST")

function printWSADATA(data)
	print("Version: ", string.format("%d.%d", LOWBYTE(data.wVersion),  HIGHBYTE(data.wVersion)))
	print("High version: ", string.format("%d.%d", LOWBYTE(data.wHighVersion),  HIGHBYTE(data.wHighVersion)))
	print("Description: ", ffi.string(data.szDescription))
	print("Status: ", ffi.string(data.szSystemStatus))

	-- To be ignored for Winsock2
	--print("Max Sockets: ", data.iMaxSockets)
	--print("Max UDP Dg: ", data.iMaxUdpDg)
	--print("Vendor Info: ", data.lpVendorInfo)
end


printWSADATA(WinSock.WSAData)

local ipn = winsock2.inet_addr("127.0.0.1")
local localhostipn = ffi.new("int[1]", ipn)

print(string.format("Loopback: 0x%x", ffi.C.INADDR_LOOPBACK))
print(string.format("Address : 0x%x",localhostipn[0]))
print(string.format("Address2: 0x%x",bswap(winsock2.inet_addr("127.0.0.1"))))


-- Get a host entry based on the address
local function printHostEntry(host)
	print(" === HOST === ")
	print("Name: ", ffi.string(host.h_name))
	print("Addr Type: ", host.h_addrtype)
	print("Addr Length: ", host.h_length)

	-- Alternate addresses
	print("Addr List: ",host.h_addr_list)
	local addrcnt = 0
	while host.h_addr_list[addrcnt] ~= nil do
		-- get a string representation of the address
		local addr = ffi.new("IN_ADDR")
		local intvalue = ffi.cast("int *", host.h_addr_list[addrcnt])
		addr.S_un.S_addr = intvalue[0]
		local addrstr = winsock2.inet_ntoa(addr)

		print(string.format("Addr List[%d]: ", addrcnt), ffi.string(addrstr), host.h_addr_list[addrcnt])
		addrcnt = addrcnt + 1
	end
	--local addrlist = host.h_addr_list[0]
end

local function printAddressInfo(info)
	print(" ==== AddressInfo ====")
	print("Flags: ", info.ai_flags)
	print("Family: ", info.ai_family)
	print("Sock Type: ", info.ai_socktype)
	print("Protocol: ", info.ai_protocol)
	print("Addr Len: ", info.ai_addrlen)
	print("Addr: ", info.ai_addr)
	print("Name: ", info.ai_canonname)
end

local hostentry = winsock2.gethostbyaddr(ffi.cast("char *", localhostipn), 4, ffi.C.AF_INET)
printHostEntry(hostentry)

local localhostname = GetLocalHostName()
print("Local Host Name: ", localhostname)

local hints = ffi.new("struct addrinfo")
--hints.ai_flags = band(C.AI_FQDN, C.AI_CANONNAME)
--hints.ai_flags = C.AI_PASSIVE
hints.ai_flags = C.AI_CANONNAME
--hints.ai_family = C.AF_INET
--hints.ai_family = C.AF_UNSPEC
hints.ai_socktype = C.SOCK_STREAM
hints.ai_protocol = C.IPPROTO_TCP
local addrinfos = ffi.new("struct addrinfo[1]")
local err = winsock2.getaddrinfo(localhostname,nil,nil,addrinfos);
print("ERROR: ", err)
print("AddrInfos: ", addrinfos)
print("AddrInfos[0]:", addrinfos[0])
--print("AddrInfos[0][0]:", addrinfos[0][0])
printAddressInfo(addrinfos[0])

hostentry = winsock2.gethostbyname("www.google.com");
printHostEntry(hostentry)

hostentry = winsock2.gethostbyname("www.microsoft.com");
printHostEntry(hostentry)

hostentry = winsock2.gethostbyname("dvice.com");
printHostEntry(hostentry)

--local avalue = MAKEWORD(5,7)
--print(string.format("0x%x", avalue))




