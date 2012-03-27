-- Put this at the top of any test
local ppath = package.path..';..\\?.lua;'
package.path = ppath;

require "guiddef"

--[[
GUID Structure too large
for inclusion in a structure?

ffi.cdef[[
// Originally from WTypes.h
typedef struct _OBJECTID {
	GUID Lineage;
    unsigned long Uniquifier;
} 	OBJECTID;
]]
--]]


print("guiddef.lua - TEST")

local guid, name = DEFINE_OLEGUID("foo", 200, 10, 20)
local iunknown, unknownguid = DEFINE_OLEGUID("iunknown", 0,0,0)

print(name, guid)
print(iunknown, unknownguid)

print("GUID NULL")
print(GUID_NULL)

print("COMPARE EQUAL")
local guid2 = GUID()
assert(GUID_NULL == guid2, "should be equal")

print("UNEQUAL")
assert(GUID_NULL ~= guid, "should be unequal")


