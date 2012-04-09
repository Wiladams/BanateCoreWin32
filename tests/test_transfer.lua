local ffi = require "ffi"

ffi.cdef[[
typedef struct {
int socket;
} FOO, *PFOO;
]]


function CreatePointerString(instance)
	if ffi.abi("64bit") then
	print("64 bit")
		return string.format("0x%016x", tonumber(ffi.cast("int64_t", ffi.cast("void *", instance))))
	elseif ffi.abi("32bit") then
	print("32 bit")
		return string.format("0x%08x", tonumber(ffi.cast("int32_t", ffi.cast("void *", instance))))
	end

	return nil
end


local instance = ffi.new("FOO")

print("Instance: ",instance)
print("Instance Pointer String: ", CreatePointerString(instance))

