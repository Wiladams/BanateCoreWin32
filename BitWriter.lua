require "BanateCore"

local byteptr = ffi.typeof("uint8_t *")

ffi.cdef[[
typedef struct {
	union {
		float f;
		double d;
		uint8_t b[8];
	} value;
} bittypes_t
]]
local bittypes = ffi.typeof("bittypes_t")
local float = ffi.typeof("float")
local double = ffi.typeof("double")






class.BitWriter()

function BitWriter:_init(bigendian)
	bigendian = bigendian or ffi.abi("be")
	self.BigEndian = bigendian
end

function BitWriter:WriteByte(bytes, value, bigendian)
	bytes[0] = value
end

function BitWriter:WriteInt16(bytes, value, bigendian)
	bytes[0] = band(rshift(value, 8), 0xff)
	bytes[1] = band(rshift(value, 0), 0xff)
end

function BitWriter:WriteInt32(bytes, value, bigendian)
	bytes[0] = band(rshift(value, 24), 0xff)
	bytes[1] = band(rshift(value, 16), 0xff)
	bytes[2] = band(rshift(value, 8), 0xff)
	bytes[3] = band(rshift(value, 0), 0xff)
end

function BitWriter:WriteInt64(bytes, value, bigendian)

	bytes[0] = band(rshift(value, 56), 0xff)
	bytes[1] = band(rshift(value, 48), 0xff)
	bytes[2] = band(rshift(value, 40), 0xff)
	bytes[3] = band(rshift(value, 32), 0xff)
	bytes[4] = band(rshift(value, 24), 0xff)
	bytes[5] = band(rshift(value, 16), 0xff)
	bytes[6] = band(rshift(value, 8), 0xff)
	bytes[7] = band(rshift(value, 0), 0xff)
end

function BitWriter:WriteSingle(bytes, value, bigendian)
	local f1 = float(value)
	local bt = bittypes()
	bt.value.f = f1

	bytes[0] = bt.value.b[0]
	bytes[1] = bt.value.b[1]
	bytes[2] = bt.value.b[2]
	bytes[3] = bt.value.b[3]
end

function BitWriter:WriteDouble(bytes, value, bigendian)
	local d1 = double(value)
	local bt = bittypes()
	bt.value.d = d1

	bytes[0] = bt.value.b[0]
	bytes[1] = bt.value.b[1]
	bytes[2] = bt.value.b[2]
	bytes[3] = bt.value.b[3]
	bytes[4] = bt.value.b[4]
	bytes[5] = bt.value.b[5]
	bytes[6] = bt.value.b[6]
	bytes[7] = bt.value.b[7]
end

