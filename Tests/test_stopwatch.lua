-- Put this at the top of any test
local ppath = package.path..';..\\?.lua;..\\core\\?.lua;'
package.path = ppath;

-- test_stopwatch.lua
local ffi = require "ffi"

require "StopWatch"
local kernel32 = ffi.load("kernel32")

print("StopWatch.lua - TEST")
local sw = StopWatch()
--print(sw)

print("Start: ", sw:Milliseconds())

for i=1,10 do
sw:Reset()
kernel32.Sleep(50)

--print("Seconds: ", sw:Seconds())
print("Milliseconds: ", sw:Milliseconds())

end
--print(sw)

