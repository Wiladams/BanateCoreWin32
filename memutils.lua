local ffi = require "ffi"


function bzero(dest, nbytes)
	ffi.Fill(dest, nbytes)
	return dest
end

function bcopy(src, dest, nbytes)
	ffi.copy(dest, src, nbytes)
end

function bcmp(ptr1, ptr2, nbytes)
	for i=0,nbytes do
		if ptr1[i] ~= ptr2[i] then return -1 end
	end

	return 0
end

function memset(dest, c, len)
	ffi.Fill(dest, len, c)
	return dest
end

function memcpy(dest, src, nbytes)
	ffi.copy(dest, src, nbytes)
end

function memcmp(ptr1, ptr2, nbytes)
	local p1 = ffi.cast("uint8_t *", ptr1)
	local p2 = ffi.cast("uint8_t *", ptr2)

	for i=0,nbytes do
		if p1[i] ~= p2[i] then return -1 end
	end

	return 0
end

