-- Put this at the top of any test
local ppath = package.path..';..\\?.lua;'
package.path = ppath;

local ffi = require "ffi"
local C = ffi.C

require "win_kernel32"


print("win_kernel32.lua - TEST")

function test_PerformanceCounter()

	local freq = GetPerformanceFrequency()
	local count = GetPerformanceCounter()

	print(freq)
	print(count)

	print(count/freq)
end

function test_GetProcAddress(library, funcname)
	ffi.load(library)
	local paddr = C.GetProcAddress(C.GetModuleHandleA(library), funcname)
	print("Proc Address: ", library, funcname, paddr)
end

test_GetProcAddress("kernel32", "GetProcAddress")
test_GetProcAddress("opengl32", "wglGetProcAddress")
test_GetProcAddress("opengl32", "wglGetExtensionsStringARB")
