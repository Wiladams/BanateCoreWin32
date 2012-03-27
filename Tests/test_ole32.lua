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
print(IID_IRpcChannel)

print("IID_IUnknown", IID_IUnknown)
print("IID_IClassFactory", IID_IClassFactory)

--[[
Similar to COM CoCreateInstance

Ideally, I'd like the calls to look like the following
FileGraphManager = COMInterface("E436EBB3-524F-11CE-9F53-0020AF0BA770")

then:

local f = FileGraphManager()
--]]


ole32.CoUninitialize();

