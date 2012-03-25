local ffi = require "ffi"
local bit = require "bit"
local band = bit.band
local bor = bit.bor
local bxor = bit.bxor
local rshift = bit.rshift
local lshift = bit.lshift

require "win_socket"

local winsock = ffi.load "ws2_32"

-- Definition of an IP based Node
local class = require "class"

class.IPNode()

function IPNode:_init(nodename)
-- use the nodename to figure out
-- the host
	local hostentry = winsock.gethostbyname(nodename);

	self.CanonicalName = ffi.string(hostentry.h_name)

	-- Alternate addresses
	self.Addresses = {}
	local addrcnt = 0
	while hostentry.h_addr_list[addrcnt] ~= nil do
		-- get a string representation of the address
		local addr = ffi.new("IN_ADDR")
		local intvalue = ffi.cast("int *", hostentry.h_addr_list[addrcnt])
		addr.S_un.S_addr = intvalue[0]
		local addrstr = ffi.string(winsock.inet_ntoa(addr))
		table.insert(self.Addresses,addrstr)
		addrcnt = addrcnt + 1
	end
end

function IPNode:__tostring()
	local res = {}
	table.insert(res,string.format("Host: %s", self.CanonicalName))
	for i=1,#self.Addresses do
		table.insert(res, string.format("\nAddress: %s", self.Addresses[i]))
	end

	return table.concat(res)
end



-- Definition of a Berkeley socket object
class.BSocket()

function BSocket:_init(af, stype, protocol)
	self.Socket = winsock.socket(af, stype, protocol)
end

function BSocket:Accept(addr, addrlen)
	local newsocket = BSocket(winsock.accept(self,addr,addrlen));

	return newsocket
end

function BSocket:Bind(name, namelen)
	local err = winsock.bind(self, name, namelen);
	return err
end

function BSocket:Connect(name, namelen)
	local err = winsock.connect(self, name, namelen);
end

function BSocket:GetName(name, namelen)
	local err = winsock.getsockname(self, name, namelen);
	return err
end

function BSocket:SetOption(level, optname, optval, optlen)
	local err = winsock.getsockopt(self, level, optname, optval, optlen);
	return err
end

function BSocket:Control(cmd, argp)
	local err = winsock.ioctlsocket(self, cmd, argp);
	return err
end

function BSocket:Listen(backlog)
	local err = winsock.listen(self, backlog);
	return err
end

function BSocket:Receive(buf, len, flags)
	local err = winsock.recv(self, buf, len, flags);
	return err
end

function BSocket:ReceiveFrom(buf, len, flags, from, fromlen)
	local err = winsock.recvfrom(self, buf, len, flags, from, fromlen);
	return err
end

function BSocket:Send(buf, len, flags)
	local err = winsock.send(self, buf, len, flags);

	return err
end

function BSocket:SendTo(buf, len, flags, to, tolen)
	local err = winsock.sendto(self, buf, len, flags, to, tolen);

	return err
end

function BSocket:SetOption(level, optname, optval, optlen)
	local err = winsock.setsockopt(self, level, optname, optval, optlen);

	return err
end

function BSocket:Shutdown(how)
	local err = winsock.shutdown(self, how);

	return err
end

