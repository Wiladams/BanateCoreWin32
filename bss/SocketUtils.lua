local ppath = package.path..';..\\?.lua'
package.path = ppath;

require "BanateCore"
require "memutils"
require "win_socket"

local wsock = ffi.load("ws2_32")


local families = {}
families[AF_INET] = "AF_INET";
families[AF_INET6] = "AF_INET6";


local socktypes = {}
socktypes[SOCK_STREAM] = "SOCK_STREAM";
socktypes[SOCK_DGRAM] = "SOCK_DGRAM";


local protocols = {
	IPPROTO_TCP = "IPPROTO_TCP",
	IPPROTO_UDP = "IPPROTO_UDP",
}



IN_ADDR = nil
IN_ADDR_mt = {
	__tostring = function(self)
		return self:GetAsString()
	end,

	__index = {
		Assign = function(self, rhs)
		--print("IN_ADDR Assign: ", rhs.s_addr)
			self.s_addr = rhs.s_addr
			return self
		end,

		GetAsString = function(self)
			local selfptr = ffi.new("struct in_addr")
			selfptr:Assign(self)
			local buf = ffi.new("char[?]", (INET_ADDRSTRLEN+1))
			local bufptr = ffi.cast("intptr_t", buf)

			wsock.inet_ntop(AF_INET, selfptr, bufptr, (INET_ADDRSTRLEN));
			local str = ffi.string(buf)
			return str;
		end,

		SetFromString = function(self, src)
			local tmpptr = ffi.new("struct in_addr[1]")
			wsock.inet_pton(AF_INET, src, tmpptr);
			self:Assign(tmpptr[0])

			return self
		end,
	},
}
IN_ADDR = ffi.metatype("struct in_addr", IN_ADDR_mt)




SOCKADDR_STORAGE = nil
SOCKADDR_STORAGE_mt = {
	__tostring = function(self)
		if self.ss_family == AF_INET then
			local selfptr = ffi.cast("struct sockaddr_in *", self)
			return string.format("AF_INET, %s,  %d", self:GetAddressString(), self:GetPort())
		end

		if self.ss_family == AF_INET6 then
			local selfptr = ffi.cast("struct sockaddr_in6 *", self)
			return string.format("AF_INET6, %s, %d", self:GetAddressString(), self:GetPort())
		end

		return ""
	end,

	__index={
		Assign = function(self, rhs)
			if rhs.ss_family == AF_INET then
				local selfptr = ffi.cast("struct sockaddr_in *", self)
				local rhsptr = ffi.cast("struct sockaddr_in *", rhs)
				local len = ffi.sizeof("struct sockaddr_in")

				memcpy(selfptr, rhs, len)
				return self
			elseif rhs.ss_family == AF_INET6 then
				local selfptr = ffi.cast("struct sockaddr_in6 *", self)
				local rhsptr = ffi.cast("struct sockaddr_in6 *", rhs)
				local len = ffi.sizeof("struct sockaddr_in6")

				memcpy(selfptr, rhs, len)
				return self
			end

			return self
		end,

		Family = function(self)
			return self.ss_family, families[self.ss_family]
		end,

		Size = function(self)
			if self.ss_family == AF_INET then
				local len = ffi.sizeof("struct sockaddr_in")
				return len
			elseif self.ss_family == AF_INET6 then
				local len = ffi.sizeof("struct sockaddr_in6")
				return len
			end

			return 0
		end,

		Clone = function(self)
			local newone = ffi.new("SOCKADDR_STORAGE")
			memcpy(newone, self, ffi.sizeof("SOCKADDR_STORAGE"))
			return newone
		end,

		Equal = function(self, rhs)
			if self.ss_family ~= rhs.ss_family then return false end

			if self.sa_family == AF_INET then
				local len = ffi.sizeof("struct sockaddr_in")
				return memcmp(self, rhs, len)
			else
				local len = ffi.sizeof("struct sockaddr_in6")
				return memcmp(self, rhs, len)
			end

			return false
		end,

		GetAddressString = function(self)
			if self.ss_family == AF_INET then
				local selfptr = ffi.cast("struct sockaddr_in *", self)
				return selfptr.sin_addr:GetAsString()
			elseif self.ss_family == AF_INET6 then
				local selfptr = ffi.cast("struct sockaddr_in6 *", self)
				local addroffset = ffi.offsetof("struct sockaddr_in6", "sin6_addr")
				local in_addr6ptr = selfptr+addroffset

				local buf = ffi.new("char[?]", (INET6_ADDRSTRLEN+1))
				local bufptr = ffi.cast("intptr_t", buf)

				wsock.inet_ntop(AF_INET6, in_addr6ptr, bufptr, (INET6_ADDRSTRLEN));
				local ipstr =  ffi.string(buf)
--print(ipstr)
				return ipstr
			end

			return nil
		end,

		SetAddressFromString = function(self, src)
			if self.ss_family == AF_INET then
				local selfptr = ffi.cast("struct sockaddr_in *", self)
				selfptr.sin_addr:SetFromString(src)

				return self
			elseif self.ss_family == AF_INET6 then
				local selfptr = ffi.cast("struct sockaddr_in6 *", self)
				local addroffset = ffi.offsetof("struct sockaddr_in6", "sin6_addr")
				local in_addrptr = selfptr+addroffset

				wsock.inet_pton(AF_INET6, src, in_addrptr);

				return self
			end

			return nil
		end,

		EqualPort = function(self, rhs)
			return self:GetPort() == rhs:GetPort()
		end,

		GetPort = function(self)
			if self.ss_family == AF_INET then
				local selfptr = ffi.cast("struct sockaddr_in *", self)
				return wsock.ntohs(selfptr.sin_port)
			elseif self.ss_family == AF_INET6 then
				local selfptr = ffi.cast("struct sockaddr_in6 *", self)
				return wsock.ntohs(selfptr.sin6_port)
			end

			return nil
		end,

		SetPort = function(self, port)
			if self.ss_family == AF_INET then
				local selfptr = ffi.cast("struct sockaddr_in *", self)
				selfptr.sin_port = wsock.htons(port);
				return self
			elseif self.ss_family == AF_INET6 then
				local selfptr = ffi.cast("struct sockaddr_in6 *", self)
				selfptr.sin6_port = wsock.htons(port);
				return self
			end

			return nil
		end,


	},
}
SOCKADDR_STORAGE = ffi.metatype("SOCKADDR_STORAGE", SOCKADDR_STORAGE_mt)


function CreateIPV4Address(addrstr, port)
	local addr = SOCKADDR_STORAGE(AF_INET)
	addr:SetPort(port)
	addr:SetAddressFromString(addrstr)

	return addr
end

function CreateIPV6Address(addrstr, port)
	local addr = SOCKADDR_STORAGE(AF_INET6)
	addr:SetPort(port)
	addr:SetAddressFromString(addrstr)

	return addr
end


function CreateSocketAddress(hostname, port)
	local addrinfos = ffi.new("PADDRINFOA[1]")
	local err = wsock.getaddrinfo(hostname,nil,nil,addrinfos);

	if err == 0 then
		local addr = addrinfos[0].ai_addr:Clone()
		addr:SetPort(port)

		-- free the addrinfos structure
		err = wsock.freeaddrinfo(addrinfos[0])

		return addr
	end

	return nil
end

function CreateIPV4WildcardAddress(family, port)
	local inetaddr = ffi.new("SOCKADDR_IN");
	inetaddr.sin_family = family;
	inetaddr.sin_addr.s_addr = wsock.htonl(INADDR_ANY);
	inetaddr.sin_port = wsock.htons(port);

	return inetaddr
end





addrinfo = nil
addrinfo_mt = {
	__tostring = function(self)
		local family = families[self.ai_family]
		--local socktype = socktypes[self.ai_socktype]
		--local protocol = protocols[self.ai_protocol]

		--local family = self.ai_family
		local socktype = self.ai_socktype
		local protocol = self.ai_protocol


		local str = string.format("Socket Type: %d, Protocol: %d, %s", socktype, protocol, tostring(self.ai_addr));

		return str
	end,

	__index = {
	},
}
addrinfo = ffi.metatype("struct addrinfo", addrinfo_mt)

