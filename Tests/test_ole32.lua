-- test_COM.lua
-- Put this at the top of any test
local ppath = package.path..';..\\?.lua;'
package.path = ppath;

local ffi = require "ffi"
local C = ffi.C

require "ObjBase"

local ole32 = ffi.load("ole32")

local res = ole32.CoInitialize(nil)

print(res)

print("IID_IRpcChannel")
print(C.IID_IRpcChannel)


ole32.CoUninitialize();

